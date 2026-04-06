
module Sync_FIFO #( 
    parameter DEPTH = 8, 
    parameter WIDTH = 8
) (
    input wire clk, 
    input wire rst, 
    input wire wr_en, 
    input wire rd_en,
    input wire [WIDTH-1:0] data_in,

    output reg [WIDTH-1:0] data_out,
    output wire full, 
    output wire empty
);

    // Pointer width: extra MSB for wrap detection
    localparam PTR_WIDTH = $clog2(DEPTH);

    reg [PTR_WIDTH:0] w_ptr, r_ptr;

    // Memory
    reg [WIDTH-1:0] Fifo [0:DEPTH-1];

    // WRITE LOGIC

    always @(posedge clk) begin
        if (rst) begin
            w_ptr <= 0;
        end 
        else if (wr_en && (!full || rd_en)) begin
            // allow write if read also happening (prevents stall at full)
            Fifo[w_ptr[PTR_WIDTH-1:0]] <= data_in;
            w_ptr <= w_ptr + 1'b1;
        end
    end

    // READ LOGIC

    always @(posedge clk) begin
        if (rst) begin
            r_ptr   <= 0;
            data_out <= 0;
        end 
        else if (rd_en && !empty) begin
            data_out <= Fifo[r_ptr[PTR_WIDTH-1:0]];
            r_ptr <= r_ptr + 1'b1;
        end
    end

    initial begin
    if (DEPTH & (DEPTH - 1))
        $error("DEPTH must be power of 2");
    end

    // STATUS FLAGS


    // EMPTY: pointers equal
    assign empty = (w_ptr == r_ptr);

    // FULL: MSB different, rest same
    assign full = (w_ptr[PTR_WIDTH] != r_ptr[PTR_WIDTH]) && (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0]);

endmodule
