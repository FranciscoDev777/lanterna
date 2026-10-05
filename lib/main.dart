import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// ============================================================
// CORES DO APLICATIVO
// ============================================================

class AppCores {
  static const amarelo = Color(0xFFFFD700);
  static const cinzaEscuro = Color(0xFF1A1A1A);
  static const cinzaMedio = Color(0xFF2C2C2C);
  static const cinzaTexto = Color(0xFF888888);

  static const vermelho = Color(0xFFEF5350);
  static const azul = Color(0xFF42A5F5);
  static const verde = Color(0xFF66BB6A);
  static const roxo = Color(0xFFAB47BC);
}

// ============================================================
// APLICATIVO
// ============================================================

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lanterna Inteligente',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppCores.amarelo,
          brightness: Brightness.dark,
        ),

        scaffoldBackgroundColor: const Color(0xFF0D0D0D),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppCores.cinzaEscuro,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),

      home: const LanternaScreen(),
    );
  }
}

// ============================================================
// TELA PRINCIPAL
// ============================================================

class LanternaScreen extends StatefulWidget {
  const LanternaScreen({super.key});

  @override
  State<LanternaScreen> createState() => _LanternaScreenState();
}

class _LanternaScreenState extends State<LanternaScreen> {
  bool _lanternaLigada = false;
  bool _modoAutomatico = false;

  // Melhoria do desafio:
  // intensidade visual da lanterna.
  double _intensidade = 1.0;

  Timer? _timerAutomatico;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timerAutomatico?.cancel();
    super.dispose();
  }

  // ==========================================================
  // LIGA / DESLIGA
  // ==========================================================

  void _alternarLanterna() {
    setState(() {
      _lanternaLigada = !_lanternaLigada;
    });
  }

  // ==========================================================
  // MODO AUTOMÁTICO
  // ==========================================================

  void _alternarModoAutomatico(bool valor) {
    setState(() {
      _modoAutomatico = valor;
    });

    if (_modoAutomatico) {
      _iniciarModoAutomatico();
    } else {
      _pararModoAutomatico();
    }
  }

  void _iniciarModoAutomatico() {
    _timerAutomatico?.cancel();

    _timerAutomatico = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (!mounted || !_modoAutomatico) {
          timer.cancel();
          return;
        }

        setState(() {
          _lanternaLigada = !_lanternaLigada;
        });
      },
    );
  }

  void _pararModoAutomatico() {
    _timerAutomatico?.cancel();
    _timerAutomatico = null;
  }

  // ==========================================================
  // ALTERAÇÃO DA INTENSIDADE
  // ==========================================================

  void _alterarIntensidade(double valor) {
    setState(() {
      _intensidade = valor;
    });
  }

  // ==========================================================
  // INTERFACE
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool ligada = _lanternaLigada;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // CABEÇALHO
            // ==================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),

                        padding: const EdgeInsets.all(8),

                        decoration: BoxDecoration(
                          color: ligada
                              ? AppCores.amarelo.withOpacity(0.15)
                              : AppCores.cinzaMedio,

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Icon(
                          Icons.flashlight_on,
                          color: ligada
                              ? AppCores.amarelo
                              : AppCores.cinzaTexto,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        'Lanterna',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),

                  // STATUS

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),

                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: ligada
                          ? AppCores.amarelo
                          : AppCores.cinzaMedio,

                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      ligada ? 'LIGADA' : 'DESLIGADA',

                      style: TextStyle(
                        color: ligada
                            ? Colors.black
                            : Colors.white70,

                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // MODO AUTOMÁTICO
            // ==================================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: _modoAutomatico
                      ? AppCores.roxo.withOpacity(0.18)
                      : AppCores.cinzaEscuro,

                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(
                    color: _modoAutomatico
                        ? AppCores.roxo
                        : Colors.white10,
                  ),
                ),

                child: Row(
                  children: [

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),

                      width: 45,
                      height: 45,

                      decoration: BoxDecoration(
                        color: _modoAutomatico
                            ? AppCores.roxo.withOpacity(0.25)
                            : AppCores.cinzaMedio,

                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        Icons.auto_mode,
                        color: _modoAutomatico
                            ? AppCores.roxo
                            : AppCores.cinzaTexto,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            'Modo Automático',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            _modoAutomatico
                                ? 'A lanterna está alternando automaticamente.'
                                : 'Ative para controlar automaticamente.',

                            style: const TextStyle(
                              color: AppCores.cinzaTexto,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Switch(
                      value: _modoAutomatico,

                      activeThumbColor: AppCores.roxo,

                      onChanged: _alternarModoAutomatico,
                    ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // ÁREA PRINCIPAL DA LANTERNA
            // ==================================================

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    // Brilho externo

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),

                      width: ligada ? 230 : 170,
                      height: ligada ? 230 : 170,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: ligada
                            ? AppCores.amarelo.withOpacity(
                                0.04 * _intensidade,
                              )
                            : Colors.transparent,

                        boxShadow: ligada
                            ? [
                                BoxShadow(
                                  color: AppCores.amarelo
                                      .withOpacity(
                                    0.25 * _intensidade,
                                  ),

                                  blurRadius: 50,
                                  spreadRadius: 20,
                                ),
                              ]
                            : [],
                      ),

                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),

                          width: ligada ? 160 : 120,
                          height: ligada ? 160 : 120,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            color: ligada
                                ? AppCores.amarelo.withOpacity(
                                    0.12 + (0.25 * _intensidade),
                                  )
                                : AppCores.cinzaEscuro,

                            border: Border.all(
                              color: ligada
                                  ? AppCores.amarelo
                                  : AppCores.cinzaMedio,

                              width: 2,
                            ),

                            boxShadow: ligada
                                ? [
                                    BoxShadow(
                                      color: AppCores.amarelo
                                          .withOpacity(
                                        0.35 * _intensidade,
                                      ),

                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : [],
                          ),

                          child: AnimatedSwitcher(
                            duration: const Duration(
                              milliseconds: 300,
                            ),

                            child: Icon(
                              ligada
                                  ? Icons.flashlight_on
                                  : Icons.flashlight_off,

                              key: ValueKey(ligada),

                              size: ligada ? 75 : 60,

                              color: ligada
                                  ? AppCores.amarelo
                                  : AppCores.cinzaTexto,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),

                      child: Text(
                        ligada
                            ? 'Iluminando o ambiente'
                            : 'Lanterna desligada',

                        key: ValueKey(ligada),

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,

                          color: ligada
                              ? AppCores.amarelo
                              : Colors.white70,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _modoAutomatico
                          ? 'Modo automático ativado'
                          : 'Controle manual',

                      style: const TextStyle(
                        color: AppCores.cinzaTexto,
                        fontSize: 13,
                      ),
                    ),

                    // ==================================================
                    // MELHORIA: INTENSIDADE
                    // ==================================================

                    const SizedBox(height: 25),

                    if (ligada)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                        ),

                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,

                              children: [
                                const Text(
                                  'Intensidade',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),

                                Text(
                                  '${(_intensidade * 100).round()}%',
                                  style: const TextStyle(
                                    color: AppCores.amarelo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Slider(
                              value: _intensidade,

                              min: 0.2,
                              max: 1.0,

                              activeColor: AppCores.amarelo,
                              inactiveColor: AppCores.cinzaMedio,

                              onChanged: _alterarIntensidade,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ==================================================
            // BOTÃO PRINCIPAL
            // ==================================================

            Padding(
              padding: const EdgeInsets.only(
                bottom: 35,
                left: 20,
                right: 20,
              ),

              child: GestureDetector(
                onTap: _alternarLanterna,

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),

                  width: 90,
                  height: 90,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: ligada
                        ? AppCores.amarelo
                        : AppCores.cinzaMedio,

                    boxShadow: ligada
                        ? [
                            BoxShadow(
                              color: AppCores.amarelo
                                  .withOpacity(0.45),

                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                          ]
                        : [],
                  ),

                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),

                    child: Icon(
                      Icons.power_settings_new,

                      key: ValueKey(ligada),

                      size: 40,

                      color: ligada
                          ? Colors.black
                          : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}