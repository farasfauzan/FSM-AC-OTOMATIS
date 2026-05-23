module ac_fsm_mealy(
    input  wire clk,
    input  wire reset,
    input  wire ce,
    input  wire w,                 // 0 = tidak ada orang, 1 = ada orang
    output reg y,                  // 0 = AC OFF, 1 = AC ON
    output wire [1:0] state_display
);

    parameter S0 = 2'b00; // Ruangan kosong
    parameter S1 = 2'b01; // Orang terdeteksi
    parameter S2 = 2'b10; // Ruangan terisi aktif

    reg [1:0] curr, next;

    assign state_display = curr;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            curr <= S0;
        else if (ce)
            curr <= next;
    end

    // Next state + output Mealy
    always @(*) begin
        next = curr;
        y = 1'b0;

        case (curr)
            S0: begin
                if (w == 1'b0) begin
                    next = S0;
                    y = 1'b0;
                end else begin
                    next = S1;
                    y = 1'b1;
                end
            end

            S1: begin
                if (w == 1'b0) begin
                    next = S0;
                    y = 1'b0;
                end else begin
                    next = S2;
                    y = 1'b1;
                end
            end

            S2: begin
                if (w == 1'b0) begin
                    next = S0;
                    y = 1'b0;
                end else begin
                    next = S2;
                    y = 1'b1;
                end
            end

            default: begin
                next = S0;
                y = 1'b0;
            end
        endcase
    end

endmodule