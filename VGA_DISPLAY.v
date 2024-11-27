module VGA_DISPLAY (  
    input wire clk,  // 25.175 MHz clock  
    output wire hsync,  
    output wire vsync,  
    output wire [2:0] rgb  
);  
    // VGA timing parameters  
    parameter H_VISIBLE = 640;  
    parameter H_FRONT_PORCH = 16;  
    parameter H_SYNC_PULSE = 96;  
    parameter H_BACK_PORCH = 48;  
    parameter H_TOTAL = 800;  
    parameter V_VISIBLE = 480;  
    parameter V_FRONT_PORCH = 10;  
    parameter V_SYNC_PULSE = 2;  
    parameter V_BACK_PORCH = 33;  
    parameter V_TOTAL = 525;  

    reg [9:0] h_count = 0;  
    reg [9:0] v_count = 0;  

    // Character ROM, 8x16 pixels, each character occupying 16 bytes  
    reg [7:0] char_rom [0:127]; // Defined for 128 characters  
    initial begin  
        // Initialize character ROM data  
        // Character "M" bitmap  
        char_rom[0] = 8'b11101110;  
        char_rom[1] = 8'b11111110;  
        char_rom[2] = 8'b11111110;  
        char_rom[3] = 8'b11101110;  
        char_rom[4] = 8'b11001110;  
        char_rom[5] = 8'b11001110;  
        char_rom[6] = 8'b11001110;  
        char_rom[7] = 8'b11001110;  
        // Character "U" bitmap  
        char_rom[8] = 8'b11001110;  
        char_rom[9] = 8'b11001110;  
        char_rom[10] = 8'b11001110;  
        char_rom[11] = 8'b11001110;  
        char_rom[12] = 8'b11001110;  
        char_rom[13] = 8'b11001110;  
        char_rom[14] = 8'b11111110;  
        char_rom[15] = 8'b01111100;  
        // Additional characters can be initialized as necessary...  
    end  

    // Horizontal sync signal  
    assign hsync = (h_count >= (H_VISIBLE + H_FRONT_PORCH)) &&   
                   (h_count < (H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE));  

    // Vertical sync signal  
    assign vsync = (v_count >= (V_VISIBLE + V_FRONT_PORCH)) &&   
                   (v_count < (V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE));  

    // RGB output generation  
    wire [7:0] char_line;   
    assign char_line = char_rom[(v_count[4:1] * 8) + h_count[6:4]]; // Correct index for 8x16 characters  

    assign rgb = (h_count < H_VISIBLE && v_count < V_VISIBLE && char_line[h_count[3:1]]) ? 3'b111 : 3'b000;  

    // Counter logic for generating h_count and v_count  
    always @(posedge clk) begin  
        // Increment horizontal count  
        if (h_count == H_TOTAL - 1) begin  
            h_count <= 0;  
            // Increment vertical count if end of horizontal count  
            if (v_count == V_TOTAL - 1) begin  
                v_count <= 0;  
            end else begin  
                v_count <= v_count + 1;  
            end  
        end else begin  
            h_count <= h_count + 1;  
        end  
    end  
endmodule