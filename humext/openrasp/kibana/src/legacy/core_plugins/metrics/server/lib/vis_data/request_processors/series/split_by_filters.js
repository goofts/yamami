'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = splitByFilter;

var _helpers = require('../../helpers');

function splitByFilter(req, panel, series) {
  return next => doc => {
    if (series.split_mode === 'filters' && series.split_filters) {
      series.split_filters.forEach(filter => {
        (0, _helpers.overwrite)(doc, `aggs.${series.id}.filters.filters.${filter.id}.query_string.query`, filter.filter || '*');
        (0, _helpers.overwrite)(doc, `aggs.${series.id}.filters.filters.${filter.id}.query_string.analyze_wildcard`, true);
      });
    }
    return next(doc);
  };
} /*
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

module.exports = exports['default'];