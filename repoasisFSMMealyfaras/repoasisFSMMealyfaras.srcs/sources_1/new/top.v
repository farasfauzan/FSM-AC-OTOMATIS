module top(
    input  wire clk_100MHz,   // Clock Nexys A7
    input  wire sw0,          // Input sensor orang: 0 kosong, 1 ada orang
    input  wire btnd,         // Reset
    output wire led_y,        // Output AC
    output wire led_hb,       // Heartbeat LED
    output wire [6:0] seg,    // 7-segment cathode
    output wire [7:0] an      // 7-segment anode
);

    wire reset;
    wire ce_1s;
    wire y;
    wire [1:0] state;

    debouncer db_reset (
        .clk(clk_100MHz),
        .btn_in(btnd),
        .btn_pulse(),
        .btn_level(reset)
    );

    clock_divider_1s div (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .ce_1s(ce_1s),
        .led_hb(led_hb)
    );

    ac_fsm_mealy fsm (
        .clk(clk_100MHz),
        .reset(reset),
        .ce(ce_1s),
        .w(sw0),
        .y(y),
        .state_display(state)
    );

    display disp (
        .clk(clk_100MHz),
        .w_in(sw0),
        .y_out(y),
        .state(state),
        .seg(seg),
        .an(an)
    );

    assign led_y = y;

endmodule