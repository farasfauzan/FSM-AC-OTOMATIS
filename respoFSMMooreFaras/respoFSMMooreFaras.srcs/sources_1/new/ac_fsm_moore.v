module ac_fsm_moore(
    input  wire clk,
    input  wire reset,
    input  wire ce,
    input  wire w,                 // 0 = tidak ada orang, 1 = ada orang
    output reg y,                  // 0 = AC OFF, 1 = AC ON
    output wire [1:0] state_display
);

    parameter S0 = 2'b00; // Ruangan kosong, AC OFF
    parameter S1 = 2'b01; // Orang terdeteksi, AC ON
    parameter S2 = 2'b10; // Ruangan terisi aktif, AC ON

    reg [1:0] curr, next;

    assign state_display = curr;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            curr <= S0;
        else if (ce)
            curr <= next;
    end

    // Next state logic
    always @(*) begin
        next = curr;

        case (curr)
            S0: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S1;
            end

            S1: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S2;
            end

            S2: begin
                if (w == 1'b0)
                    next = S0;
                else
                    next = S2;
            end

            // Kalau masuk state tidak valid 11, paksa balik ke S0
            default: next = S0;
        endcase
    end

    // Output Moore: hanya bergantung pada state
    always @(*) begin
        case (curr)
            S0: y = 1'b0;
            S1: y = 1'b1;
            S2: y = 1'b1;
            default: y = 1'b0;
        endcase
    end

endmodule