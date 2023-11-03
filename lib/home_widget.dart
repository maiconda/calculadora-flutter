import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String calcule = '';
  double result = 0;

  void concat(String tecla) {
    if (tecla == '0') {
      int lastIndexPlus = calcule.lastIndexOf('+');
      int lastIndexHyphen = calcule.lastIndexOf('-');
      int lastIndexSlash = calcule.lastIndexOf('÷');
      int lastIndexMultiply = calcule.lastIndexOf('×');

      int lastIndex = -1;

      if (lastIndexPlus > lastIndexHyphen &&
          lastIndexPlus > lastIndexSlash &&
          lastIndexPlus > lastIndexMultiply) {
        lastIndex = lastIndexPlus;
      } else if (lastIndexHyphen > lastIndexSlash &&
          lastIndexHyphen > lastIndexMultiply) {
        lastIndex = lastIndexHyphen;
      } else if (lastIndexSlash > lastIndexMultiply) {
        lastIndex = lastIndexSlash;
      } else {
        lastIndex = lastIndexMultiply;
      }

      if (lastIndex != -1) {
        String novaString = calcule.substring(lastIndex + 1);
        if (novaString != '0') {
          calcule += tecla;
        }
      }
    } else {
      calcule += tecla;
    }
  }

  void exclude() {
    if (calcule.isNotEmpty) {
      calcule = calcule.substring(0, calcule.length - 1);
    }
  }

  void clear() {
    calcule = '';
    result = 0;
  }

  void calculate() {
    List<String> pilhaOperadores = [];
    List<double> pilhaNumeros = [];
    String numero = '';
    bool negativo = false;

    for (int i = 0; i < calcule.length; i++) {
      final char = calcule[i];

      if (char == '+' || char == '-' || char == '×' || char == '÷') {
        if (numero.isNotEmpty) {
          double valor = double.parse(numero);
          if (negativo) {
            valor = -valor;
            negativo = false;
          }
          pilhaNumeros.add(valor);
          numero = '';
        }

        if (pilhaOperadores.isNotEmpty) {
          while (pilhaOperadores.isNotEmpty &&
              (getPrecedencia(char) <= getPrecedencia(pilhaOperadores.last))) {
            realizarOperacao(pilhaOperadores.removeLast(), pilhaNumeros);
          }
        }

        pilhaOperadores.add(char);
      } else if (char == '-') {
        if (numero.isEmpty) {
          negativo = true;
        } else {
          numero += char;
        }
      } else {
        numero += char;
      }
    }

    if (numero.isNotEmpty) {
      double valor = double.parse(numero);
      if (negativo) {
        valor = -valor;
      }
      pilhaNumeros.add(valor);
    }

    while (pilhaOperadores.isNotEmpty) {
      realizarOperacao(pilhaOperadores.removeLast(), pilhaNumeros);
    }

    if (pilhaNumeros.length == 1) {
      result = pilhaNumeros.first;
    }
  }

  int getPrecedencia(String operador) {
    if (operador == '+' || operador == '-') {
      return 1;
    } else if (operador == '×' || operador == '÷') {
      return 2;
    }
    return 0;
  }

  void realizarOperacao(String operador, List<double> pilhaNumeros) {
    double num2 = pilhaNumeros.removeLast();
    double num1 = pilhaNumeros.removeLast();
    double resultado = 0.0;

    if (operador == '+') {
      resultado = num1 + num2;
    } else if (operador == '-') {
      resultado = num1 - num2;
    } else if (operador == '×') {
      resultado = num1 * num2;
    } else if (operador == '÷') {
      resultado = num1 / num2;
    }

    pilhaNumeros.add(resultado);
  }

  String convertResult(){
    String formattedNumber = result.toString();
    if (result == result.toInt()) {
      formattedNumber = result.toInt().toString();
    }

    return formattedNumber;
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.black),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.height * 0.27,
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.only(left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Text(
                          calcule == '' ? '0' : calcule,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 45,
                            color: Color(0xFFE1E1E1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: Text(
                        convertResult(),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 70,
                          color: Color(0xFF989898),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          clear();
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0xFFC5C5C5),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              'AC',
                              style: TextStyle(
                                  color: Color(0xFF646464), fontSize: 29),
                            ),
                          )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.all(6)),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.all(6)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          exclude();
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          padding: EdgeInsets.only(right: 3),
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Icon(
                              Icons.backspace,
                              size: 50,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('7');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '7',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('8');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '8',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('9');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '9',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('÷');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '÷',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('4');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '4',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('5');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '5',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('6');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '6',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('×');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                              child: Text(
                            '×',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('1');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '1',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('2');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '2',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('3');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '3',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('-');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '-',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('0');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '0',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('.');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0x9E949494),
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          calculate();
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '=',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          concat('+');
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: Text(
                              '+',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 40),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
