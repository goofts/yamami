/*
 * Licensed to Elasticsearch B.V. under one or more contributor
 * license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright
 * ownership. Elasticsearch B.V. licenses this file to you under
 * the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import 'plugins/kbn_vislib_vis_types/controls/vislib_basic_options';
import _ from 'lodash';
import { BaseMapsVisualizationProvider } from '../../tile_map/public/base_maps_visualization';
import { ORIGIN } from '../../tile_map/common/origin';
import ChoroplethLayer from './choropleth_layer';
import { truncatedColorMaps }  from 'ui/vislib/components/color/truncated_colormaps';
import AggResponsePointSeriesTooltipFormatterProvider from './tooltip_formatter';
import 'ui/vis/map/service_settings';
import { toastNotifications } from 'ui/notify';

export function RegionMapsVisualizationProvider(Private, config, i18n, regionmapsConfig, serviceSettings) {

  const tooltipFormatter = Private(AggResponsePointSeriesTooltipFormatterProvider);
  const BaseMapsVisualization = Private(BaseMapsVisualizationProvider);

  return class RegionMapsVisualization extends BaseMapsVisualization {

    constructor(container, vis) {
      super(container, vis);
      this._vis = this.vis;
      this._choroplethLayer = null;
    }

    async render(esResponse, status) {
      await super.render(esResponse, status);
      if (this._choroplethLayer) {
        await this._choroplethLayer.whenDataLoaded();
      }
    }

    async _updateData(table) {
      this._chartData = table;
      let results;
      if (!table || !table.rows.length || table.columns.length !== 2) {
        results = [];
      } else {
        const termColumn = table.columns[0].id;
        const valueColumn = table.columns[1].id;
        results = table.rows.map(row => {
          const term = row[termColumn];
          const value = row[valueColumn];
          return { term: term, value: value };
        });
      }

      const selectedLayer = await this._loadConfig(this.vis.params.selectedLayer);
      if (!this.vis.params.selectedJoinField && selectedLayer) {
        this.vis.params.selectedJoinField = selectedLayer.fields[0];
      }

      if (!selectedLayer) {
        return;
      }

      this._updateChoroplethLayerForNewMetrics(
        selectedLayer.name,
        selectedLayer.attribution,
        this._vis.params.showAllShapes,
        results
      );
      const metricsAgg = _.first(this._vis.getAggConfig().bySchemaName.metric);
      this._choroplethLayer.setMetrics(results, metricsAgg);
      this._setTooltipFormatter();

      this._kibanaMap.useUiStateFromVisualization(this._vis);
    }

    async _loadConfig(fileLayerConfig) {
      // Load the selected layer from the metadata-service.
      // Do not use the selectedLayer from the visState.
      // These settings are stored in the URL and can be used to inject dirty display content.
      if (!fileLayerConfig) {
        return;
      }

      if (
        fileLayerConfig.isEMS || //Hosted by EMS. Metadata needs to be resolved through EMS
        (fileLayerConfig.layerId && fileLayerConfig.layerId.startsWith(`${ORIGIN.EMS}.`)) //fallback for older saved objects
      ) {
        return await serviceSettings.loadFileLayerConfig(fileLayerConfig);
      }

      //Configured in the kibana.yml. Needs to be resolved through the settings.
      const configuredLayer = regionmapsConfig.layers.find(
        (layer) => layer.name === fileLayerConfig.name
      );

      if (configuredLayer) {
        return {
          ...configuredLayer,
          attribution: _.escape(configuredLayer.attribution ? configuredLayer.attribution : ''),
        };
      }

      return null;
    }

    async  _updateParams() {

      await super._updateParams();

      const selectedLayer = await this._loadConfig(this.vis.params.selectedLayer);

      if (!this.vis.params.selectedJoinField && selectedLayer) {
        this.vis.params.selectedJoinField = selectedLayer.fields[0];
      }

      if (!this.vis.params.selectedJoinField || !selectedLayer) {
        return;
      }

      this._updateChoroplethLayerForNewProperties(
        selectedLayer.name,
        selectedLayer.attribution,
        this._vis.params.showAllShapes
      );
      this._choroplethLayer.setJoinField(this.vis.params.selectedJoinField.name);
      this._choroplethLayer.setColorRamp(truncatedColorMaps[this.vis.params.colorSchema].value);
      this._choroplethLayer.setLineWeight(this.vis.params.outlineWeight);
      this._setTooltipFormatter();

    }

    _updateChoroplethLayerForNewMetrics(name, attribution, showAllData, newMetrics) {
      if (this._choroplethLayer && this._choroplethLayer.canReuseInstanceForNewMetrics(name, showAllData, newMetrics)) {
        return;
      }
      return this._recreateChoroplethLayer(name, attribution, showAllData);
    }

    _updateChoroplethLayerForNewProperties(name, attribution, showAllData) {
      if (this._choroplethLayer && this._choroplethLayer.canReuseInstance(name, showAllData)) {
        return;
      }
      return this._recreateChoroplethLayer(name, attribution, showAllData);
    }

    _recreateChoroplethLayer(name, attribution, showAllData) {

      this._kibanaMap.removeLayer(this._choroplethLayer);


      if (this._choroplethLayer) {
        this._choroplethLayer = this._choroplethLayer.cloneChoroplethLayerForNewData(
          name,
          attribution,
          this.vis.params.selectedLayer.format,
          showAllData,
          this.vis.params.selectedLayer.meta,
          this.vis.params.selectedLayer
        );
      } else {
        this._choroplethLayer = new ChoroplethLayer({
          name,
          attribution,
          format: this.vis.params.selectedLayer.format,
          showAllShapes: showAllData,
          meta: this.vis.params.selectedLayer.meta,
          layerConfig: this.vis.params.selectedLayer
        });
      }

      this._choroplethLayer.on('select', (event) => {


        if (!this._isAggReady()) {
          //even though we have maps data available and have added the choropleth layer to the map
          //the aggregation may not be available yet
          return;
        }

        const rowIndex = this._chartData.rows.findIndex(row => row[0] === event);
        this._vis.API.events.filter({ table: this._chartData, column: 0, row: rowIndex, value: event });
      });

      this._choroplethLayer.on('styleChanged', (event) => {
        const shouldShowWarning = this._vis.params.isDisplayWarning && config.get('visualization:regionmap:showWarnings');
        if (event.mismatches.length > 0 && shouldShowWarning) {
          toastNotifications.addWarning({
            title: i18n('regionMap.visualization.unableToShowMismatchesWarningTitle', {
              defaultMessage: 'Unable to show {mismatchesLength} {oneMismatch, plural, one {result} other {results}} on map',
              values: {
                mismatchesLength: event.mismatches.length,
                oneMismatch: event.mismatches.length > 1 ? 0 : 1,
              },
            }),
            text: i18n('regionMap.visualization.unableToShowMismatchesWarningText', {
              defaultMessage: 'Ensure that each of these term matches a shape on that shape\'s join field: {mismatches}',
              values: {
                mismatches: event.mismatches ? event.mismatches.join(', ') : '',
              },
            }),
          });
        }
      });


      this._kibanaMap.addLayer(this._choroplethLayer);

    }

    _isAggReady() {
      return this._vis.getAggConfig().bySchemaName.segment && this._vis.getAggConfig().bySchemaName.segment[0];
    }


    _setTooltipFormatter() {
      const metricsAgg = _.first(this._vis.getAggConfig().bySchemaName.metric);
      if (this._isAggReady()) {
        const fieldName = this._vis.getAggConfig().bySchemaName.segment[0].makeLabel();
        this._choroplethLayer.setTooltipFormatter(tooltipFormatter, metricsAgg, fieldName);
      } else {
        this._choroplethLayer.setTooltipFormatter(tooltipFormatter, metricsAgg, null);
      }
    }

  };

}
