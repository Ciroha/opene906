/*Copyright 2020-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// ADDR is 20-bit, 4K address
// Flag includes: Strong Order, Cacheable, Bufferable
`define SYSMAP_BASE_ADDR0  20'hffff     //32'h00000000-32'h0fffefff该段空间是指令空间
`define SYSMAP_FLG0        3'b011       //Weak Order, Cacheable, Bufferable

`define SYSMAP_BASE_ADDR1  20'h1ffff    //32'h0ffff000-32'h1fffefff
`define SYSMAP_FLG1        3'b000       //Weak Order, Non-cacheable, Non-bufferable

`define SYSMAP_BASE_ADDR2  20'h3ffff    //32'h1ffff000-32'h3fffefff
`define SYSMAP_FLG2        3'b011       //Weak Order, Cacheable, Bufferable

`define SYSMAP_BASE_ADDR3  20'h6ffff    //32'h3ffff000-32'h6fffefff
`define SYSMAP_FLG3        3'b000       //Weak Order, Non-cacheable, Non-bufferable

`define SYSMAP_BASE_ADDR4  20'haffff    //32'h6ffff000-32'hafffefff
`define SYSMAP_FLG4        3'b011       //Weak Order, Cacheable, Bufferable

`define SYSMAP_BASE_ADDR5  20'hf0000    //32'hf0000000-32'hefffffff
`define SYSMAP_FLG5        3'b100       //Strong Order, Non-cacheable, Non-bufferable

`define SYSMAP_BASE_ADDR6  20'hfff5f    //32'hf0000000-32'hfff5efff
`define SYSMAP_FLG6        3'b011       //Weak Order, Cacheable, Bufferable

`define SYSMAP_BASE_ADDR7  20'hfffff    //32'hfff5f000-32'hffffefff
`define SYSMAP_FLG7        3'b100       //Strong Order, Non-cacheable, Non-bufferable
