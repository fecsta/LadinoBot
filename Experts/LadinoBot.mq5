﻿//+------------------------------------------------------------------+
//|                                                       Ladino.mq5 |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright     "Rodrigo Landim"
#property link          "http://www.emagine.com.br"
#property version       "1.03"
#property description   "Free Expert Advisor working using HiLo and MM starting the"
#property description   "operation when the HiLo change and MM cross the candle."
#property description   "Just for testing MQL5 LANGUAGE DETECTION"

#include <Trade/Trade.mqh>
#include <LadinoBot/Utils.mqh>
#include <LadinoBot/Views/LogPanel.mqh>
#include <LadinoBot/LadinoBot.mqh>

LadinoBot _ladinoBot;

input ENUM_HORARIO      HorarioEntrada = HORARIO_1000;                  // Start Time
input ENUM_HORARIO      HorarioFechamento = HORARIO_1600;               // Closing Time
input ENUM_HORARIO      HorarioSaida = HORARIO_1630;                    // Exit Time
input ENUM_OPERACAO     TipoOperacao = COMPRAR_VENDER;                  // Operation type
input ENUM_ATIVO        TipoAtivo = ATIVO_INDICE;                       // Asset type
input ENUM_RISCO        GestaoRisco = RISCO_PROGRESSIVO;                // Risk management
input ENUM_ENTRADA      CondicaoEntrada = HILO_CRUZ_MM_T1_TICK;         // Input condition
input double            ValorCorretagem = 0.16;                         // Brokerage value
input double            ValorPonto = 0.2;                               // Value per point

input bool              T1LinhaTendencia = true;                        // T1 Use Trendline
input bool              T1SRTendencia = false;                          // T1 Support and Resistance
input int               T1HiloPeriodo = 13;                             // T1 HiLo Periods
input bool              T1HiloTendencia = true;                         // T1 HiLo set Trend
input int               T1MM = 9;                                       // T1 Moving average

input bool              T2GraficoExtra = false;                         // T2 Graph Extra
input ENUM_TIMEFRAMES   T2TempoGrafico = PERIOD_M20;                    // T2 Graph Time
input int               T2HiloPeriodo = 13;                             // T2 HiLo Periods
input bool              T2HiloTendencia = false;                        // T2 HiLo set Trend
input bool              T2SRTendencia = false;                          // T2 Support and Resistance
input int               T2MM = 9;                                       // T2 Moving average

input bool              T3GraficoExtra = false;                         // T3 Graph Extra
input ENUM_TIMEFRAMES   T3TempoGrafico = PERIOD_H2;                     // T3 Graph Time
input bool              T3HiloAtivo = false;                            // T3 HiLo Active
input int               T3HiloPeriodo = 5;                              // T3 HiLo Periods
input bool              T3HiloTendencia = true;                         // T3 HiLo set Trend
input bool              T3SRTendencia = false;                          // T3 Support and Resistance
input int               T3MM = 9;                                       // T3 Moving average

input double            StopLossMin = 30;                               // Stop Min Loss
input double            StopLossMax = 50;                               // Stop Max Loss
input double            StopExtra = 20;                                 // Stop Extra
input ENUM_STOP         StopInicial = STOP_T1_VELA_ATUAL;               // Stop Initial
input double            StopFixo = 0;                                   // Stop fixed value
input bool              ForcarOperacao = true;                          // Force operation
input bool              ForcarEntrada = true;                           // Force entry

input double            LTExtra = 10;                                   // Trendline Extra
input int               GanhoMaximo = 400;                              // Daily Max Gain
input int               PerdaMaxima = -30;                              // Daily Max Loss
input double            GanhoMaximoPosicao = 400;                       // Operation Max Gain
input bool              AumentoAtivo = false;                           // Run Position Increase
input double            AumentoStopExtra = 20;                          // Run Position Stop Extra
input int               AumentoMinimo = 80;                             // Run Position Increase Minimal
input int               BreakEven = 0;                                  // Break Even Position
input int               BreakEvenValor = 0;                             // Break Even Value
input int               BreakEvenVolume = 0;                            // Break Even Volume
input int               InicialVolume = 2;                              // Initial Volume
input int               MaximoVolume = 2;                               // Max Volume

input ENUM_OBJETIVO     ObjetivoCondicao1 = OBJETIVO_FIXO;              // Goal 1 Condition
input int               ObjetivoVolume1 = 1;                            // Goal 1 Volume
input int               ObjetivoPosicao1 = 40;                          // Goal 1 Position
input ENUM_STOP         ObjetivoStop1 = STOP_T1_VELA_ATENRIOR;          // Goal 1 Stop
input ENUM_OBJETIVO     ObjetivoCondicao2 = OBJETIVO_NENHUM;              // Goal 2 Condition
input int               ObjetivoVolume2 = 1;                            // Goal 2 Volume
input int               ObjetivoPosicao2 = 0;                           // Goal 2 Position
input ENUM_STOP         ObjetivoStop2 = STOP_T1_VELA_ATENRIOR;          // Goal 2 Stop
input ENUM_OBJETIVO     ObjetivoCondicao3 = OBJETIVO_FIXO;              // Goal 3 Condition
input int               ObjetivoVolume3 = 0;                            // Goal 3 Volume
input int               ObjetivoPosicao3 = 0;                           // Goal 3 Position
input ENUM_STOP         ObjetivoStop3 = STOP_T2_VELA_ATENRIOR;          // Goal 3 Stop

void inicializarParametro() {

   _ladinoBot.setHorarioEntrada(HorarioEntrada);
   _ladinoBot.setHorarioFechamento(HorarioFechamento);
   _ladinoBot.setHorarioSaida(HorarioSaida);
   _ladinoBot.setTipoOperacao(TipoOperacao);
   _ladinoBot.setTipoAtivo(TipoAtivo);
   _ladinoBot.setGestaoRisco(GestaoRisco);
   _ladinoBot.setCondicaoEntrada(CondicaoEntrada);
   _ladinoBot.setValorCorretagem(ValorCorretagem);
   _ladinoBot.setValorPonto(ValorPonto);

   _ladinoBot.setT1LinhaTendencia(T1LinhaTendencia);
   _ladinoBot.setT1SRTendencia(T1SRTendencia);
   _ladinoBot.setT1HiloPeriodo(T1HiloPeriodo);
   _ladinoBot.setT1HiloTendencia(T1HiloTendencia);
   _ladinoBot.setT1MM(T1MM);

   _ladinoBot.setT2GraficoExtra(T2GraficoExtra);
   _ladinoBot.setT2TempoGrafico(T2TempoGrafico);
   _ladinoBot.setT2HiloPeriodo(T2HiloPeriodo);
   _ladinoBot.setT2HiloTendencia(T2HiloTendencia);
   _ladinoBot.setT2SRTendencia(T2SRTendencia);
   _ladinoBot.setT2MM(T2MM);

   _ladinoBot.setT3GraficoExtra(T3GraficoExtra);
   _ladinoBot.setT3TempoGrafico(T3TempoGrafico);
   _ladinoBot.setT3HiloAtivo(T3HiloAtivo);
   _ladinoBot.setT3HiloPeriodo(T3HiloPeriodo);
   _ladinoBot.setT3HiloTendencia(T3HiloTendencia);
   _ladinoBot.setT3SRTendencia(T3SRTendencia);
   _ladinoBot.setT3MM(T3MM);

   _ladinoBot.setStopLossMin(StopLossMin);
   _ladinoBot.setStopLossMax(StopLossMax);
   _ladinoBot.setStopExtra(StopExtra);
   _ladinoBot.setStopInicial(StopInicial);
   _ladinoBot.setStopFixo(StopFixo);
   _ladinoBot.setForcarOperacao(ForcarOperacao);
   _ladinoBot.setForcarEntrada(ForcarEntrada);

   _ladinoBot.setLTExtra(LTExtra);
   _ladinoBot.setGanhoMaximo(GanhoMaximo);
   _ladinoBot.setPerdaMaxima(PerdaMaxima);
   _ladinoBot.setGanhoMaximoPosicao(GanhoMaximoPosicao);
   _ladinoBot.setAumentoAtivo(AumentoAtivo);
   _ladinoBot.setAumentoStopExtra(AumentoStopExtra);
   _ladinoBot.setAumentoMinimo(AumentoMinimo);
   _ladinoBot.setBreakEven(BreakEven);
   _ladinoBot.setBreakEvenValor(BreakEvenValor);
   _ladinoBot.setBreakEvenVolume(BreakEvenVolume);
   _ladinoBot.setInicialVolume(InicialVolume);
   _ladinoBot.setMaximoVolume(MaximoVolume);

   _ladinoBot.setObjetivoCondicao1(ObjetivoCondicao1);
   _ladinoBot.setObjetivoVolume1(ObjetivoVolume1);
   _ladinoBot.setObjetivoPosicao1(ObjetivoPosicao1);
   _ladinoBot.setObjetivoStop1(ObjetivoStop1);
   _ladinoBot.setObjetivoCondicao2(ObjetivoCondicao2);
   _ladinoBot.setObjetivoVolume2(ObjetivoVolume2);
   _ladinoBot.setObjetivoPosicao2(ObjetivoPosicao2);
   _ladinoBot.setObjetivoStop2(ObjetivoStop2);
   _ladinoBot.setObjetivoCondicao3(ObjetivoCondicao3);
   _ladinoBot.setObjetivoVolume3(ObjetivoVolume3);
   _ladinoBot.setObjetivoPosicao3(ObjetivoPosicao3);
   _ladinoBot.setObjetivoStop3(ObjetivoStop3);
}

int OnInit() {

   EventSetTimer(60); 

   ChartSetInteger(0, CHART_SHOW_GRID, false);
   ChartSetInteger(0, CHART_MODE, CHART_CANDLES);
   ChartSetInteger(0, CHART_AUTOSCROLL, true);
   
   _logs.inicializar();
   _logs.adicionarLog("Initializing LadinoBot...");
   
   inicializarParametro();
   _ladinoBot.criarStatusControls();
   _ladinoBot.inicializar();
   
   _logs.adicionarLog("LadinoBot successfully launched.");
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
   EventKillTimer();
}

void OnTick() {
   _ladinoBot.onTick();
}

void OnTimer(){
   _ladinoBot.onTimer();
}

double OnTester() {
   return _ladinoBot.onTester();
}

void OnTradeTransaction( 
   const MqlTradeTransaction& trans,   // estrutura das transações de negócios 
   const MqlTradeRequest&     request, // estrutura solicitada 
   const MqlTradeResult&      result   // resultado da estrutura 
) {
   _ladinoBot.aoNegociar(trans, request, result);
}
