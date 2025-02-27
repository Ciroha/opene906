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

// &ModuleBeg; @23
module pa_ifu_pcgen(
  btb_pcgen_tar_pc,
  btb_xx_chgflw_vld,
  cp0_ifu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  ctrl_pcgen_inst_vld,
  ctrl_pcgen_pipedown,
  forever_cpuclk,
  id_pred_pcgen_chgflw_pc,
  id_pred_pcgen_chgflw_vld,
  id_pred_pcgen_inst_vld,
  ifetch_pcgen_addr,
  ifetch_pcgen_data,
  ifetch_pcgen_grant,
  ifetch_pcgen_grant_dp,
  ifetch_xx_not_busy,
  ifu_idu_chgflw_flush,
  ifu_iu_chgflw_pc,
  ifu_iu_chgflw_vld,
  ipack_pcgen_reissue,
  ipack_pcgen_reissue_gate,
  iu_ifu_tar_pc,
  iu_ifu_tar_pc_vld,
  iu_ifu_tar_pc_vld_gate,
  pad_yy_icg_scan_en,
  pcgen_btb_addr,
  pcgen_btb_pc,
  pcgen_ctrl_chgflw_vld,
  pcgen_ibuf_chgflw_vld,
  pcgen_id_pred_btb_tar_pc,
  pcgen_id_pred_btb_tar_vld,
  pcgen_id_pred_flush_vld,
  pcgen_id_pred_idpc,
  pcgen_id_pred_ifpc,
  pcgen_ifetch_addr,
  pcgen_ifetch_chgflw_vld,
  pcgen_ifetch_ifpc,
  pcgen_ifetch_seq_addr,
  pcgen_ipack_chgflw_vld,
  pcgen_top_btb_tar_vld,
  pcgen_top_buf_chgflw,
  rtu_ifu_chgflw_pc,
  rtu_ifu_chgflw_vld,
  rtu_ifu_flush_fe,
  sysio_ifu_rst_addr,
  vec_pcgen_chgflw_vld,
  vec_pcgen_idle,
  vec_pcgen_inst_fetch,
  vec_pcgen_iu_chgflw,
  vec_pcgen_pc_flop,
  vec_pcgen_rst_vld,
  vec_pcgen_tar_pc
);

// &Ports; @24
input   [31:0]  btb_pcgen_tar_pc;         
input           btb_xx_chgflw_vld;        //来自分支目标缓冲的指令流改变信号
input           cp0_ifu_icg_en;           
input           cp0_yy_clk_en;            
input           cpurst_b;                 
input           ctrl_pcgen_inst_vld;      
input           ctrl_pcgen_pipedown;      
input           forever_cpuclk;           
input   [31:0]  id_pred_pcgen_chgflw_pc;  
input           id_pred_pcgen_chgflw_vld; //来自id阶段的指令预测模块的指令流改变信号
input           id_pred_pcgen_inst_vld;   
input   [31:0]  ifetch_pcgen_addr;        
input   [31:0]  ifetch_pcgen_data;        
input           ifetch_pcgen_grant;       
input           ifetch_pcgen_grant_dp;    
input           ifetch_xx_not_busy;       
input           ipack_pcgen_reissue;      
input           ipack_pcgen_reissue_gate; 
input   [31:0]  iu_ifu_tar_pc;            
input           iu_ifu_tar_pc_vld;        
input           iu_ifu_tar_pc_vld_gate;   
input           pad_yy_icg_scan_en;       
input   [31:0]  rtu_ifu_chgflw_pc;        
input           rtu_ifu_chgflw_vld;       //退休单元的指令流更改
input           rtu_ifu_flush_fe;         
input   [31:0]  sysio_ifu_rst_addr;       
input           vec_pcgen_chgflw_vld;     //来自vec模块的指令流更改
input           vec_pcgen_idle;           
input           vec_pcgen_inst_fetch;     
input           vec_pcgen_iu_chgflw;      
input           vec_pcgen_pc_flop;        
input           vec_pcgen_rst_vld;        
input   [31:0]  vec_pcgen_tar_pc;         
output          ifu_idu_chgflw_flush;     
output  [31:0]  ifu_iu_chgflw_pc;         
output          ifu_iu_chgflw_vld;        
output  [31:0]  pcgen_btb_addr;           
output  [31:0]  pcgen_btb_pc;             
output          pcgen_ctrl_chgflw_vld;    
output          pcgen_ibuf_chgflw_vld;    
output  [31:0]  pcgen_id_pred_btb_tar_pc; 
output          pcgen_id_pred_btb_tar_vld; 
output          pcgen_id_pred_flush_vld;  
output  [31:0]  pcgen_id_pred_idpc;       
output  [31:0]  pcgen_id_pred_ifpc;       
output  [31:0]  pcgen_ifetch_addr;        
output          pcgen_ifetch_chgflw_vld;  
output  [31:0]  pcgen_ifetch_ifpc;        //保留的IF阶段的PC值
output  [31:0]  pcgen_ifetch_seq_addr;    
output          pcgen_ipack_chgflw_vld;   
output          pcgen_top_btb_tar_vld;    
output          pcgen_top_buf_chgflw;     

// &Regs; @25
reg     [31:0]  btb_tar_pc;               
reg             btb_tar_vld;              
reg     [31:0]  pcgen_addr;               //寄存器信号，存储和更新当前的PC值
reg             pcgen_buf_chgflw;         //缓冲的改变指令流请求
reg     [31:0]  pcgen_delay_pc;           //指令冲刷情况下对应的pc地址
reg     [31:0]  pcgen_idpc;               
reg     [31:0]  pcgen_ifpc;               //指令获取单元的pc地址值
reg     [31:0]  pcgen_pc;                 

// &Wires; @26
wire            btb_chgflw_vld;           
wire    [31:0]  btb_pcgen_tar_pc;         
wire            btb_tar_clk;              
wire            btb_tar_icg_en;           
wire            btb_xx_chgflw_vld;        
wire            cp0_ifu_icg_en;           
wire            cp0_yy_clk_en;            
wire            cpurst_b;                 
wire            ctrl_pcgen_inst_vld;      
wire            ctrl_pcgen_pipedown;      
wire            forever_cpuclk;           
wire    [31:0]  id_pred_pcgen_chgflw_pc;  
wire            id_pred_pcgen_chgflw_vld; 
wire            id_pred_pcgen_inst_vld;   
wire    [31:0]  ifetch_pcgen_addr;        
wire    [31:0]  ifetch_pcgen_data;        
wire            ifetch_pcgen_grant;       
wire            ifetch_pcgen_grant_dp;    
wire            ifetch_xx_not_busy;       
wire            ifpc_updt_en;             
wire            ifu_idu_chgflw_flush;     
wire    [31:0]  ifu_iu_chgflw_pc;         
wire            ifu_iu_chgflw_vld;        
wire            ipack_pcgen_reissue;      
wire            ipack_pcgen_reissue_gate; 
wire    [31:0]  iu_ifu_tar_pc;            
wire            iu_ifu_tar_pc_vld;        
wire            iu_ifu_tar_pc_vld_gate;   
wire            pad_yy_icg_scan_en;       
wire    [31:0]  pcgen_addr_inc;           
wire    [31:0]  pcgen_btb_addr;           
wire    [31:0]  pcgen_btb_pc;             
wire            pcgen_chgflw_vld;         
wire            pcgen_chgflw_vld_gate;    
wire            pcgen_cpuclk;             
wire            pcgen_ctrl_chgflw_vld;    
wire    [31:0]  pcgen_fetch_pc;           
wire            pcgen_flush_vld;          //指令冲刷有效，包括从退休单元、中断、执行单元传来的冲刷信号
wire            pcgen_ibuf_chgflw_vld;    
wire            pcgen_icg_en;             
wire    [31:0]  pcgen_id_pred_btb_tar_pc; 
wire            pcgen_id_pred_btb_tar_vld; 
wire            pcgen_id_pred_flush_vld;  
wire    [31:0]  pcgen_id_pred_idpc;       
wire    [31:0]  pcgen_id_pred_ifpc;       
wire            pcgen_idpc_clk;           
wire    [31:0]  pcgen_ifetch_addr;        
wire            pcgen_ifetch_chgflw_vld;  
wire    [31:0]  pcgen_ifetch_ifpc;        
wire    [31:0]  pcgen_ifetch_seq_addr;    
wire            pcgen_ipack_chgflw_vld;   
wire            pcgen_top_btb_tar_vld;    
wire            pcgen_top_buf_chgflw;     
wire    [31:0]  rtu_ifu_chgflw_pc;        
wire            rtu_ifu_chgflw_vld;       
wire            rtu_ifu_flush_fe;         
wire    [31:0]  sysio_ifu_rst_addr;       
wire            vec_pcgen_chgflw_vld;     
wire            vec_pcgen_inst_fetch;     
wire            vec_pcgen_iu_chgflw;      
wire            vec_pcgen_pc_flop;        
wire            vec_pcgen_rst_vld;        
wire    [31:0]  vec_pcgen_tar_pc;         


//==========================================================
// PC Generator Module
// 1. ICG Instance
// 2. Judge the priority of PC sources
// 3. IF PC Maintain
// 4. ID PC Maintain
//==========================================================

//------------------------------------------------
// 1. ICG Instance
//------------------------------------------------
assign pcgen_icg_en = pcgen_chgflw_vld_gate
                   | ifetch_pcgen_grant_dp
                   | pcgen_buf_chgflw
                   | ipack_pcgen_reissue_gate
                   | vec_pcgen_rst_vld
                   | vec_pcgen_pc_flop;
// &Instance("gated_clk_cell", "x_ifu_pcgen_icg_cell"); @45
gated_clk_cell  x_ifu_pcgen_icg_cell (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (pcgen_cpuclk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (pcgen_icg_en      ),
  .module_en          (cp0_ifu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @46
//          .external_en (1'b0), @47
//          .global_en   (cp0_yy_clk_en), @48
//          .module_en   (cp0_ifu_icg_en), @49
//          .local_en    (pcgen_icg_en), @50
//          .clk_out     (pcgen_cpuclk) @51
//        ); @52

assign btb_tar_icg_en = btb_tar_vld | btb_xx_chgflw_vld;
// &Instance("gated_clk_cell", "x_ifu_pcgen_btb_tar_icg_cell"); @55
gated_clk_cell  x_ifu_pcgen_btb_tar_icg_cell (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (btb_tar_clk       ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (btb_tar_icg_en    ),
  .module_en          (cp0_ifu_icg_en    ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// &Connect(.clk_in      (forever_cpuclk), @56
//          .external_en (1'b0), @57
//          .global_en   (cp0_yy_clk_en), @58
//          .module_en   (cp0_ifu_icg_en), @59
//          .local_en    (btb_tar_icg_en), @60
//          .clk_out     (btb_tar_clk) @61
//        ); @62

// &Instance("gated_clk_cell", "x_ifu_pcgen_idpc_icg_cell"); @64
gated_clk_cell  x_ifu_pcgen_idpc_icg_cell (
  .clk_in              (forever_cpuclk     ),
  .clk_out             (pcgen_idpc_clk     ),
  .external_en         (1'b0               ),
  .global_en           (cp0_yy_clk_en      ),
  .local_en            (ctrl_pcgen_inst_vld),
  .module_en           (cp0_ifu_icg_en     ),
  .pad_yy_icg_scan_en  (pad_yy_icg_scan_en )
);

// &Connect(.clk_in      (forever_cpuclk), @65
//          .external_en (1'b0), @66
//          .global_en   (cp0_yy_clk_en), @67
//          .module_en   (cp0_ifu_icg_en), @68
//          .local_en    (ctrl_pcgen_inst_vld), @69
//          .clk_out     (pcgen_idpc_clk) @70
//        ); @71

//------------------------------------------------
// 2. Judge the priority of PC sources
// HAD > Vector > BJU > RAS > BHT > BTB > Inc |PC的优先级,硬件大于中断大于分支跳转大于RAS大于BHT大于BTB大于自增
// Todo: Parallel Case?
//------------------------------------------------
// &CombBeg; @78
always @( vec_pcgen_tar_pc[31:0]
       or iu_ifu_tar_pc[31:0]
       or rtu_ifu_chgflw_pc[31:0]
       or vec_pcgen_chgflw_vld
       or rtu_ifu_chgflw_vld)
begin
  if(vec_pcgen_chgflw_vld)
    pcgen_delay_pc[31:0] = vec_pcgen_tar_pc[31:0];//中断的目标地址
  else if(rtu_ifu_chgflw_vld)
    pcgen_delay_pc[31:0] = rtu_ifu_chgflw_pc[31:0];//分支预测失误/异常的处理
  else// if(iu_ifu_tar_pc_vld)
    pcgen_delay_pc[31:0] = iu_ifu_tar_pc[31:0];//执行单元的分支跳转相关指令
// &CombEnd; @85
end

//整体上分支预测是先从btb获取结果，然后和id_pred的结果进行比较，不一致需要对btb中的结果进行修改并更改指令流
// &CombBeg; @87
always @( id_pred_pcgen_chgflw_pc[31:0]
       or id_pred_pcgen_chgflw_vld
       or pcgen_addr[31:0]
       or btb_pcgen_tar_pc[31:0]
       or pcgen_ifpc[31:0]
       or pcgen_buf_chgflw
       or btb_xx_chgflw_vld)
begin
  if(pcgen_buf_chgflw)
    pcgen_pc[31:0] = pcgen_ifpc[31:0];
  else if(id_pred_pcgen_chgflw_vld)
    pcgen_pc[31:0] = id_pred_pcgen_chgflw_pc[31:0];//id阶段的分支预测结果
  else if(btb_xx_chgflw_vld)
    pcgen_pc[31:0] = btb_pcgen_tar_pc[31:0];//命中btb直接跳转
  else
    pcgen_pc[31:0] = pcgen_addr[31:0];//正常情况下，pcgen的pc值为pcgen_addr
// &CombEnd; @96
end

assign pcgen_flush_vld  = rtu_ifu_chgflw_vld
                       | vec_pcgen_chgflw_vld
                       | iu_ifu_tar_pc_vld;//一些需要进行冲刷的请求
assign pcgen_chgflw_vld = pcgen_flush_vld
                       | id_pred_pcgen_chgflw_vld
                       | btb_xx_chgflw_vld;
assign pcgen_chgflw_vld_gate = rtu_ifu_chgflw_vld
                       | vec_pcgen_chgflw_vld
                       | iu_ifu_tar_pc_vld_gate
                       | id_pred_pcgen_chgflw_vld
                       | btb_xx_chgflw_vld;

always @ (posedge pcgen_cpuclk or negedge cpurst_b)
begin
  if(~cpurst_b)
    pcgen_addr[31:0] <= 32'b0;
  else if(vec_pcgen_rst_vld)//rst信号
    pcgen_addr[31:0] <= sysio_ifu_rst_addr[31:0];
  else if(pcgen_chgflw_vld & ~ifetch_pcgen_grant & ifetch_xx_not_busy)//取指模块空闲且没有握手信号
    pcgen_addr[31:0] <= pcgen_pc[31:0];
  else if(vec_pcgen_pc_flop)//获取中断的地址成功
    pcgen_addr[31:0] <= ifetch_pcgen_data[31:0];
  else if(ipack_pcgen_reissue)//ipack的重发射请求
    pcgen_addr[31:0] <= ifetch_pcgen_addr[31:0];
  else if(pcgen_buf_chgflw & ~ifetch_pcgen_grant & ifetch_xx_not_busy)//TODO 尝试恢复？不确定
    pcgen_addr[31:0] <= pcgen_ifpc[31:0];
  else if(ifetch_pcgen_grant)
    pcgen_addr[31:0] <= pcgen_addr_inc[31:0];
  else
    pcgen_addr[31:0] <= pcgen_addr[31:0];//停滞一个周期
end

assign pcgen_addr_inc[31:0] = {pcgen_pc[31:2], 2'b0} + 32'h4;

assign pcgen_fetch_pc[31:0] = ifetch_xx_not_busy ? pcgen_pc[31:0]//正常执行路径下的pc值
                                                 : pcgen_addr[31:0];//异常处理/特殊情况下的入口
//assign pcgen_fetch_pc[31:0] = pcgen_pc[31:0];

//------------------------------------------------
// 3. IF PC Maintain  |IF阶段PC信号保留，确保信号的恢复
//------------------------------------------------
always @ (posedge pcgen_cpuclk or negedge cpurst_b)
begin
  if(~cpurst_b)
    pcgen_buf_chgflw <= 1'b0;
  else if(ifpc_updt_en)// & ~ifetch_xx_not_busy)
    pcgen_buf_chgflw <= 1'b1;//缓冲下来在下个周期改变指令流
  else if(ifetch_xx_not_busy & pcgen_buf_chgflw)
    pcgen_buf_chgflw <= 1'b0;
end

assign ifpc_updt_en = pcgen_flush_vld//保留的IFU的PC允许更新信号
                   | id_pred_pcgen_chgflw_vld & ~ifetch_xx_not_busy;//TODO ifetch_xx_not_busy是什么
always @ (posedge pcgen_cpuclk or negedge cpurst_b)
begin
  if(~cpurst_b)
    pcgen_ifpc[31:0] <= 32'b0;
  else if(pcgen_flush_vld)
    pcgen_ifpc[31:0] <= pcgen_delay_pc[31:0];
  else if(ifpc_updt_en)// & ~ifetch_xx_not_busy)
    pcgen_ifpc[31:0] <= pcgen_pc[31:0];
  else if(ifetch_pcgen_grant)
    pcgen_ifpc[31:0] <= pcgen_pc[31:0];
  else
    pcgen_ifpc[31:0] <= pcgen_ifpc[31:0];
end

assign pcgen_ifetch_ifpc[31:0] = pcgen_ifpc[31:0];

//------------------------------------------------
// 4. ID PC Maintain  |译码阶段的PC保留
// Todo: Reduce Resources
//------------------------------------------------
always @ (posedge pcgen_idpc_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
    pcgen_idpc[31:0] <= 32'b0;
  else if(ctrl_pcgen_pipedown)
    pcgen_idpc[31:0] <= pcgen_ifpc[31:0];
  else
    pcgen_idpc[31:0] <= pcgen_idpc[31:0];
end

//------------------------------------------------
// 5. BTB Target PC 
//------------------------------------------------
assign btb_chgflw_vld = ~pcgen_flush_vld & ~rtu_ifu_flush_fe
                     & ~id_pred_pcgen_chgflw_vld & ~pcgen_buf_chgflw
                     & btb_xx_chgflw_vld;
always @ (posedge btb_tar_clk or negedge cpurst_b)
begin
  if(~cpurst_b)
  begin
    btb_tar_vld      <= 1'b0;
    btb_tar_pc[31:0] <= 32'b0;
  end
  else if(pcgen_flush_vld | id_pred_pcgen_chgflw_vld | rtu_ifu_flush_fe)
  begin
    btb_tar_vld      <= 1'b0;
    btb_tar_pc[31:0] <= btb_tar_pc[31:0];
  end
  else if(btb_chgflw_vld)//只有在btb改变指令流信号有效时生效
  begin
    btb_tar_vld      <= 1'b1;
    btb_tar_pc[31:0] <= btb_pcgen_tar_pc[31:0];
  end
  else if(btb_tar_vld & id_pred_pcgen_inst_vld)
  begin
    btb_tar_vld      <= 1'b0;
    btb_tar_pc[31:0] <= btb_tar_pc[31:0];
  end
end

//==========================================================
// Rename for Output
//==========================================================

// Output to ifetch
assign pcgen_ifetch_addr[31:0] = pcgen_fetch_pc[31:0];
assign pcgen_ifetch_seq_addr[31:0] = pcgen_addr[31:0];
assign pcgen_ifetch_chgflw_vld = pcgen_buf_chgflw
                              | id_pred_pcgen_chgflw_vld
                              | btb_xx_chgflw_vld;

// Output to ctrl
assign pcgen_ctrl_chgflw_vld = pcgen_flush_vld | pcgen_buf_chgflw | id_pred_pcgen_chgflw_vld;

// Output to BTB
assign pcgen_btb_pc[31:0]   = pcgen_fetch_pc[31:0];//当前指令的PC地址
assign pcgen_btb_addr[31:0] = pcgen_addr[31:0];

// Output to ipack
assign pcgen_ipack_chgflw_vld = pcgen_flush_vld | pcgen_buf_chgflw | id_pred_pcgen_chgflw_vld;

// Output to ibuf
assign pcgen_ibuf_chgflw_vld  = pcgen_flush_vld;

// Output to top
assign pcgen_top_buf_chgflw   = pcgen_buf_chgflw;
assign pcgen_top_btb_tar_vld  = btb_tar_vld;

// Output to ID Prediction
assign pcgen_id_pred_ifpc[31:0]       = pcgen_ifpc[31:0];
assign pcgen_id_pred_idpc[31:0]       = pcgen_idpc[31:0];
assign pcgen_id_pred_btb_tar_vld      = btb_tar_vld;
assign pcgen_id_pred_btb_tar_pc[31:0] = btb_tar_pc[31:0];
assign pcgen_id_pred_flush_vld        = pcgen_flush_vld;

// Output to IDU
assign ifu_idu_chgflw_flush     = iu_ifu_tar_pc_vld;
//assign ifu_idu_id_pc[31:0]      = pcgen_idpc[31:0];

assign ifu_iu_chgflw_vld        = rtu_ifu_chgflw_vld
                               | vec_pcgen_iu_chgflw;
assign ifu_iu_chgflw_pc[31:0]   = vec_pcgen_inst_fetch ? pcgen_addr[31:0] 
                                                       : pcgen_delay_pc[31:0];

// &Force("input", "vec_pcgen_idle"); @259
// &Force("nonport", "rst_done"); @261

// &ModuleEnd; @291
endmodule


