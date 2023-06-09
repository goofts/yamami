'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = ratios;

var _bucket_transform = require('../../helpers/bucket_transform');

var _bucket_transform2 = _interopRequireDefault(_bucket_transform);

var _helpers = require('../../helpers');

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

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

/* eslint max-len:0 */
const filter = metric => metric.type === 'filter_ratio';
function ratios(req, panel, series) {
  return next => doc => {
    if (series.metrics.some(filter)) {
      series.metrics.filter(filter).forEach(metric => {
        (0, _helpers.overwrite)(doc, `aggs.${series.id}.aggs.timeseries.aggs.${metric.id}-numerator.filter`, {
          query_string: { query: metric.numerator || '*', analyze_wildcard: true }
        });
        (0, _helpers.overwrite)(doc, `aggs.${series.id}.aggs.timeseries.aggs.${metric.id}-denominator.filter`, {
          query_string: { query: metric.denominator || '*', analyze_wildcard: true }
        });

        let numeratorPath = `${metric.id}-numerator>_count`;
        let denominatorPath = `${metric.id}-denominator>_count`;

        if (metric.metric_agg !== 'count' && _bucket_transform2.default[metric.metric_agg]) {
          let metricAgg;
          try {
            metricAgg = _bucket_transform2.default[metric.metric_agg]({
              type: metric.metric_agg,
              field: metric.field
            });
          } catch (e) {
            metricAgg = {};
          }
          const aggBody = { metric: metricAgg };
          (0, _helpers.overwrite)(doc, `aggs.${series.id}.aggs.timeseries.aggs.${metric.id}-numerator.aggs`, aggBody);
          (0, _helpers.overwrite)(doc, `aggs.${series.id}.aggs.timeseries.aggs.${metric.id}-denominator.aggs`, aggBody);
          numeratorPath = `${metric.id}-numerator>metric`;
          denominatorPath = `${metric.id}-denominator>metric`;
        }

        (0, _helpers.overwrite)(doc, `aggs.${series.id}.aggs.timeseries.aggs.${metric.id}`, {
          bucket_script: {
            buckets_path: {
              numerator: numeratorPath,
              denominator: denominatorPath
            },
            script: 'params.numerator != null && params.denominator != null && params.denominator > 0 ? params.numerator / params.denominator : 0'
          }
        });
      });
    }
    return next(doc);
  };
}
module.exports = exports['default'];