'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = splitByTerm;

var _helpers = require('../../helpers');

function splitByTerm(req, panel) {
  return next => doc => {
    panel.series.filter(c => c.aggregate_by && c.aggregate_function).forEach(column => {
      (0, _helpers.overwrite)(doc, `aggs.pivot.aggs.${column.id}.terms.field`, column.aggregate_by);
      (0, _helpers.overwrite)(doc, `aggs.pivot.aggs.${column.id}.terms.size`, 100);
      if (column.filter) {
        (0, _helpers.overwrite)(doc, `aggs.pivot.aggs.${column.id}.column_filter.filter.query_string.query`, column.filter);
        (0, _helpers.overwrite)(doc, `aggs.pivot.aggs.${column.id}.column_filter.filter.query_string.analyze_wildcard`, true);
      }
    });
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