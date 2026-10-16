module contador_buffer_tb();
    reg clock;             // Sinal de clk
    reg resetar;           // Sinal de reset
    reg iniciar;           // Gatilho de start
  	wire [3:0] contador;    // Saída do count

    // Instância do módulo contador_buffer
    contador_buffer dut (
        .clock(clock),
        .resetar(resetar),
        .iniciar(iniciar),
        .contador(contador)
    );

  	// Simulacao do clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    // Simulação dos cenários
    initial begin
      	$monitor($time, ": clock=%b resetar=%b iniciar=%b contador=%d", clock, resetar, iniciar, contador);
      	$dumpfile("dump.vcd");
      	$dumpvars(0, contador_buffer_tb);
      
        // Inicialização dos sinais
        resetar = 0;
      	iniciar = 0;
        
      	// O contador será ativado apenas quando um ”gatilho” externo indicar que o
		// carregamento do vı́deo começou (inı́cio da transmissão).
      	#10
      	iniciar = 1;
      
      	// Após 7 segundos de operação, o sistema deve acionar um reset no contador,
		// simulando a necessidade de esvaziar o buffer para liberar espaço para novos
		// pacotes.
      	#70
		resetar = 1;
      
      	#10
      	resetar = 0;
      
      	// Depois do reset, o contador continuará ligado e operando normalmente por
		// mais 20 segundos, até o final da simulação.
      	#200
      	iniciar = 0;
      
      	#10
      	$finish;
    end
endmodule
