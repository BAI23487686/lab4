`timescale 1ns / 1ps  

module tb_VGA_DISPLAY;  

    // Parameters  
    parameter CLK_PERIOD = 40; // Clock period for roughly 25.175 MHz  

    // Testbench signals  
    reg clk;  
    reg hsync;  
    reg vsync;  
    wire [2:0] rgb;  

    // Instantiate the VGA_DISPLAY module  
    VGA_DISPLAY uut (  
        .clk(clk),  
        .hsync(hsync),  
        .vsync(vsync),  
        .rgb(rgb)  
    );  

    // Clock generation  
    initial begin  
        clk = 0;  
        forever #(CLK_PERIOD / 2) clk = ~clk; // Toggle clock every half period  
    end  

    // Monitor signals  
    initial begin  
        $monitor("Time: %0t | H Count: %d | V Count: %d | HSync: %b | VSync: %b | RGB: %b",   
                 $time, uut.h_count, uut.v_count, hsync, vsync, rgb);  
    end  

    // Run the simulation  
    initial begin  
        // Run for enough time to cover several vertical frames  
        repeat (2000) @(posedge clk); // Adjust the duration based on simulation needs  
        $finish; // End the simulation  
    end  

endmodule