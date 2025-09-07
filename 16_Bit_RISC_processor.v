Source Code 

module instruction_decoder( 
input wire [15:0] I_instruction, // 16-bit instruction 
input wire I_clk, 
input wire I_enable, 
output reg [4:0] O_alu_opcode,   // ALU opcode (bits 15:11) 
output reg [2:0] O_select_A,     // Register selector A (bits 10:8) 
output reg [2:0] O_select_B,     // Register selector B (bits 7:5) 
output reg [2:0] O_select_D,     // Register selector D (bits 4:2) 
output reg [7:0] O_immediate,    // Immediate value (bits 7:0) 
output reg O_reg_write_enable    // Register write enable 
); 

// Initialization 
initial begin 
O_alu_opcode = 5'b0; 
O_select_A = 3'b0; 
O_select_B = 3'b0; 
O_select_D = 3'b0; 
O_immediate = 8'b0; 
O_reg_write_enable = 1'b0; 
end 

// Instruction Decoder block 
always @(negedge I_clk) begin 
if (I_enable) begin 
// Decoding fields directly from instruction bits 
O_alu_opcode   <= I_instruction[15:11]; 
O_select_A     <= I_instruction[10:8]; 
O_select_B     <= I_instruction[7:5]; 
O_select_D     
<= I_instruction[4:2]; 
O_immediate    <= I_instruction[7:0]; 
// Register write enable (basic example: active for certain opcodes) 
case (I_instruction[15:12]) 
4'b0111, // Write M 
4'b1000, // Immediate low 
4'b1001: // Immediate high 
O_reg_write_enable <= 1'b1; 
default: 
O_reg_write_enable <= 1'b0; 
endcase 
end 
end 
endmodule 

module fake_ram ( 
input wire I_clk, 
input wire I_wr_enable, 
input wire [3:0] I_addr,                // 4 bits, so 0-8 valid addresses for 9 locations 
input wire [15:0] I_data_in, 
output reg [15:0] O_data_out 
); 
// Internal memory: 9 x 16-bit locations (simulate 32 bytes) 
reg [15:0] mem [0:8]; 
initial begin 
mem[0] = 16'b1000111100001111; 
mem[1] = 16'b1011101111110000; 
mem[11] = 16'b1000000000111111; 
mem[12] = 16'b1100111100001000; 
mem[13] = 16'b0101010101010101; 
mem[14] = 16'b0011001100110011; 
mem[15] = 16'b1111000011110000; 
mem[16] = 16'b0000111100001111; 
mem[17] = 16'd0; 
O_data_out = 16'd0; 
end 
always @(negedge I_clk) begin 
if (I_wr_enable) 
mem[I_addr] <= I_data_in; 
O_data_out <= mem[I_addr]; 
end 
endmodule 

module alu ( 
input wire I_clk, 
input wire I_enable, 
input wire [4:0] I_alu_opcode,      // 5-bit ALU opcode 
input wire [15:0] I_data_A,         // Operand A 
input wire [15:0] I_data_B,         // Operand B 
input wire [7:0] I_immediate,       // Immediate data 
output reg [15:0] O_data_result,    // Result 
output reg O_should_branch          // Handshake signal for jump 
); 
reg [17:0] int_result; // Internal result calculation 
initial begin 
int_result
      =
 18'b0; 
O_data_result   = 16'b0; 
O_should_branch = 1'b0; 
end 
wire opcode_lsb      
= I_alu_opcode[0];    // Signed/unsigned or hi/lo operation 
wire [3:0] opcode    = I_alu_opcode[4:1];  // Actual opcode 
localparam ADD      
= 4'd0; 
localparam SUB      = 4'd1; 
localparam OR_GATE  = 4'd2; 
localparam AND_GATE = 4'd3; 
localparam XOR_GATE = 4'd4; 
localparam NOT_GATE = 4'd5; 
localparam LOAD     = 4'd8; 
localparam CMP
 localparam SHL      
      =
 4'd9; 
= 4'd10; 
localparam SHR      = 4'd11; 
localparam JMP_ADDR = 4'd12; 
localparam JMP_REG  = 4'd13; 
always @(negedge I_clk) begin 
if (I_enable) begin 
int_result
      =
 18'b0; 
O_data_result   = 16'b0; 
O_should_branch = 1'b0; 
case (opcode) 
ADD: begin 
if (opcode_lsb) 
int_result = $signed(I_data_A) + $signed(I_data_B); 
else 
int_result = I_data_A + I_data_B; 
O_data_result = int_result[15:0]; 
end 
SUB: begin 
if (opcode_lsb) 
int_result = $signed(I_data_A) - $signed(I_data_B); 
else 
int_result = I_data_A - I_data_B; 
O_data_result = int_result[15:0]; 
end 

OR_GATE:  O_data_result = I_data_A | I_data_B; 
AND_GATE: O_data_result = I_data_A & I_data_B; 
XOR_GATE: O_data_result = I_data_A ^ I_data_B; 
NOT_GATE: O_data_result = ~I_data_A; 
LOAD: begin 
if (opcode_lsb) 
O_data_result = {I_immediate, 8'h00}; // Load high, pad low 
else 
O_data_result = {8'h00, I_immediate}; // Load low 
end 

CMP: begin 
if (opcode_lsb) begin 
// Signed comparison flags in result bits 
O_data_result[0] = ($signed(I_data_A) == $signed(I_data_B)); 
O_data_result[1] = ($signed(I_data_A) == 0); 
O_data_result[2] = ($signed(I_data_B) == 0); 
O_data_result[3] = ($signed(I_data_A) > $signed(I_data_B)); 
O_data_result[4] = ($signed(I_data_A) < $signed(I_data_B)); 
end else begin 
O_data_result = (I_data_A == I_data_B); 
O_data_result[1] = (I_data_A == 0); 
O_data_result[2] = (I_data_B == 0); 
O_data_result[3] = (I_data_A > I_data_B); 
O_data_result[4] = (I_data_A < I_data_B); 
end 
// Pad rest of result as needed; already zeroed above 
end 

SHL: O_data_result = I_data_A << I_data_B[3:0]; 
SHR: O_data_result = I_data_A >> I_data_B[3:0]; 
JMP_ADDR: begin 
if (opcode_lsb) 
O_data_result = I_data_A; 
else 
O_data_result = {8'b0, I_immediate}; 
O_should_branch = 1'b1; 
end 
JMP_REG: begin 
O_data_result = I_data_B; 
O_should_branch = 1'b1; 
end 
default: begin 
O_data_result   = 16'd0; 
O_should_branch = 1'b0; 
end 
endcase 
end else begin 
O_should_branch = 1'b0; 
end 
end 
endmodule 

module register_file ( 
input wire I_clk, 
input wire I_enable, 
input wire I_wr_enable, 
input wire [2:0] I_select_A, 
input wire [2:0] I_select_B, 
input wire [2:0] I_select_D, 
input wire [15:0] I_data_D,            // ALU output or data to be written 
output reg [15:0] O_data_A, 
output reg [15:0] O_data_B 
); 

// Declare internal register array (8 registers of 16 bits) 
reg [15:0] registers [0:7]; 
integer count; 
initial begin 
O_data_A = 16'd0; 
O_data_B = 16'd0; 
for (count = 0; count < 8; count = count + 1) begin 
registers[count] = 16'd0; 
end 
end 
always @(negedge I_clk) begin 
if (I_enable && I_wr_enable) begin 
registers[I_select_D] <= I_data_D; 
end 
// Output selected register values 
O_data_A <= registers[I_select_A]; 
O_data_B <= registers[I_select_B]; 
end 
endmodule 

module program_counter_unit ( 
input wire I_clk, 
input wire [1:0] I_opcode,         // Only two bits used for case (jump decisions) 
input wire [15:0] I_PC_addr,       // Address input for jumps 
output reg [15:0] O_PC
 ); 
initial begin 
O_PC = 16'd0; 
end 
always @(negedge I_clk) begin 
case (I_opcode) 
             //
 Output program counter value 
2'b00: O_PC = O_PC;                    // Hold at same instruction 
2'b01: O_PC = O_PC + 16'd1;            // Next instruction (sequential) 
2'b10: O_PC = I_PC_addr;               // Jump to specified address 
2'b11: O_PC = 16'd0;                   // Reset program counter 
default: O_PC = O_PC; 
endcase 
end 
endmodule