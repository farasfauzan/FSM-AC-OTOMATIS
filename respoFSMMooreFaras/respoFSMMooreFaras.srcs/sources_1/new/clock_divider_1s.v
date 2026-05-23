module clock_divider_1s(
    input wire clk_100MHz,
    input wire reset,
    output reg ce_1s,
    output reg led_hb
);

    localparam MAX = 100_000_000; // 1 detik untuk clock 100 MHz

    reg [26:0] count = 0;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset) begin
            count <= 0;
            ce_1s <= 0;
            led_hb <= 0;
        end else begin
            if (count >= MAX - 1) begin
                count <= 0;
                ce_1s <= 1;
                led_hb <= ~led_hb;
            end else begin
                count <= count + 1;
                ce_1s <= 0;
            end
        end
    end

endmodule