TestBench Code 

module decoder_tb; 
reg [15:0] Inst; 
reg clk; 
reg enable; 
wire [4:0] alu_opcode; 
wire [2:0] select_A; 
wire [2:0] select_B; 
wire [2:0] select_D; 
wire [15:0] immediate; 
wire reg_write_enable; 
initial begin 
clk = 0; 
enable = 0; 
Inst = 0; 
#10 enable = 1; 
#10 Inst = 16'b0000001110001000; // Example instruction: add r7 = r1 + r2 
end 
always #5 clk = ~clk; 
instruction_decoder uut ( 
.I_instruction(Inst), 
.I_clk(clk), 
.I_enable(enable), 
.O_alu_opcode(ALU_opcode), 
.O_select_A(select_A), 
.O_select_B(select_B), 
.O_select_D(select_D), 
.O_immediate(immediate), 
.O_reg_write_enable(reg_write_enable) 
); 
Endmodule 
module register_file_tb; 
reg clk; 
reg enable; 
reg wr_enable; 
reg [2:0] select_A; 
reg [2:0] select_B; 
reg [2:0] select_D; 
reg [15:0] data_D; 
wire [15:0] data_A; 
wire [15:0] data_B; 
integer i; 
register_file uut ( 
.clk(clk), 
.enable(enable), 
.wr_enable(wr_enable), 
.select_A(select_A), 
.select_B(select_B), 
.select_D(select_D), 
.data_D(data_D), 
.data_A(data_A), 
.data_B(data_B) 
); 
initial begin 
clk = 0; enable = 0; wr_enable = 0; data_D = 0; select_A = 0; select_B = 0; select_D = 0; 
#10 enable = 1; 
// Write some data to registers 
wr_enable = 1; select_D = 3'd0; data_D = 16'hFFFF; 
#10 select_D = 3'd1; data_D = 16'hAAAA; 
#10 select_D = 3'd2; data_D = 16'h5555; 
#10 wr_enable = 0; 
// Read registers 
select_A = 3'd0; select_B =3'd1; 
#20 select_A = 3'd1; select_B = 3'd2; 
#20 select_A = 3'd0; select_B = 3'd2; 
end 
always #5 clk = ~clk; 
endmodule 
module control_unit( 
input wire I_clk, 
input wire I_reset, 
output wire O_fetch_enable, 
output wire O_dec_enable, 
output wire O_reg_read_enable, 
output wire O_alu_enable, 
output wire O_reg_write_enable, 
output wire O_mem_enable 
); 
// Localparam states 
localparam FETCH = 3'd0, 
DECODE = 3'd1, 
REG_READ = 3'd2, 
ALU_OP = 3'd3, 
REG_WRITE = 3'd4, 
MEM_WRITE = 3'd5; 
reg [2:0] state; 
// Initialization 
initial begin 
state = FETCH; 
end 
// State transition logic 
always @(posedge I_clk or posedge I_reset) begin 
if (I_reset) 
state <= FETCH; 
else begin 
case (state) 
FETCH:     state <= DECODE; 
DECODE:    state <= REG_READ; 
REG_READ:  state <= ALU_OP; 
ALU_OP:    state <= REG_WRITE; 
REG_WRITE: state <= MEM_WRITE; 
MEM_WRITE: state <= FETCH; 
default:   state <= FETCH; 
endcase 
end 
end 
// Assign enables based on state (one-hot encoding) 
assign O_fetch_enable    
assign O_dec_enable       
 = (state == FETCH); 
= (state == DECODE); 
assign O_reg_read_enable  = (state == REG_READ); 
assign O_alu_enable       
= (state == ALU_OP); 
assign O_reg_write_enable = (state == REG_WRITE); 
assign O_mem_enable    
endmodule