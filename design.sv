module contador_buffer (
    input clock,           // Sinal de clk
    input resetar,         // Sinal de reset
    input iniciar,         // Gatilho de início do carregamento
  output reg [3:0] contador // count
);

    always @(posedge clock) begin
        if (resetar) begin
            contador <= 0;         // reset o counter
        end else if (iniciar) begin
        	if(contador == 12)
            	contador <= 0;
        	else
            	contador <= contador + 1;
        end
    end
endmodule
