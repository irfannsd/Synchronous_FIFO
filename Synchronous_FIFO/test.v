
`include "Synchronous_FIFO.v"

`timescale 1ns/1ps

module tb_Sync_FIFO;

    parameter DEPTH = 8;
    parameter WIDTH = 8;

    reg clk, rst;
    reg wr_en, rd_en;
    reg [WIDTH-1:0] data_in;

    wire [WIDTH-1:0] data_out;
    wire full, empty;

    // DUT
    Sync_FIFO #(DEPTH, WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock
    always #5 clk = ~clk;

    // Reference model
    reg [WIDTH-1:0] ref_mem [0:DEPTH-1];
    integer w_ref = 0, r_ref = 0;

    // -------------------------------
    // WRITE TASK (FINAL)
    // -------------------------------
    task write(input [WIDTH-1:0] data);
        reg do_write;
    begin
        @(negedge clk);

        do_write = !full;   // capture condition BEFORE clock

        wr_en = 1;
        rd_en = 0;
        data_in = data;

        @(posedge clk);     // write happens

        @(negedge clk);
        wr_en = 0;

        if (do_write) begin
            ref_mem[w_ref] = data;
            w_ref = (w_ref + 1) % DEPTH;
        end
    end
    endtask

    // -------------------------------
    // READ TASK (FINAL)
    // -------------------------------
    task read;
        reg do_read;
    begin
        @(negedge clk);

        do_read = !empty;   // capture condition BEFORE clock

        rd_en = 1;
        wr_en = 0;

        @(posedge clk);     // read happens

        @(negedge clk);
        rd_en = 0;

        if (do_read) begin
            if (data_out !== ref_mem[r_ref]) begin
                $display("ERROR: Expected %0d, Got %0d at time %0t",
                         ref_mem[r_ref], data_out, $time);
            end else begin
                $display("READ OK: %0d at time %0t", data_out, $time);
            end

            r_ref = (r_ref + 1) % DEPTH;
        end else begin
            $display("READ BLOCKED (EMPTY) at time %0t", $time);
        end
    end
    endtask

    // -------------------------------
    // INITIAL BLOCK
    // -------------------------------
    initial begin
        // waveform dump
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb_Sync_FIFO);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #20 rst = 0;

        // TEST 1: Write
        $display("\nTEST 1: Writing data");
        write(10);
        write(20);
        write(30);

        // TEST 2: Read
        $display("\nTEST 2: Reading data");
        read();
        read();
        read();

        // TEST 3: Fill FIFO
        $display("\nTEST 3: Fill FIFO");
        repeat (DEPTH) write($random);

        // TEST 4: Overflow
        $display("\nTEST 4: Overflow attempt");
        write(99);

        // TEST 5: Empty FIFO
        $display("\nTEST 5: Empty FIFO");
        repeat (DEPTH) read();

        // TEST 6: Underflow
        $display("\nTEST 6: Underflow attempt");
        read();

        // TEST 7: Simultaneous Read/Write
        $display("\nTEST 7: Simultaneous Read/Write");

        write(55);
        write(66);

        @(negedge clk);
        wr_en = 1;
        rd_en = 1;
        data_in = 77;

        @(posedge clk);

        @(negedge clk);
        wr_en = 0;
        rd_en = 0;

        #50;
        $display("\nSimulation Finished");
        $finish;
    end

endmodule