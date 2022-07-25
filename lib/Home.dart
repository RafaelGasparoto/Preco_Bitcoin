import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _preco = "0";
  String _moeda = "BRL";

  final _symbols = {
    'BRL': 'R\$',
    'USD': 'US\$',
    'JPY': '¥',
    'EUR': '€',
    'RUB': '₽'
  };

  final _items = ['BRL', 'USD', 'JPY', 'EUR', 'RUB'];

  Future<Map> _atualizarPreco() async {
    var url = Uri.parse("https://www.blockchain.com/pt/ticker");
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
    /*
    setState(() {
      _preco = retorno[_moeda]["buy"].toString();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valor do Bitcoin"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("imagens/bitcoin.png"),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder<Map>(
                        future: _atualizarPreco(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              _preco = "Carregando....";
                              break;
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                _preco = "Error ao carregar dados.";
                              } else {
                                _preco =
                                    snapshot.data![_moeda]["buy"].toString();
                              }
                              break;
                            case ConnectionState.active:
                              break;
                          }
                          return Text(
                            "$_preco ${_symbols[_moeda]!}",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          );
                        }),
                    DropdownButton(
                      items: _items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _moeda = newValue!;
                        });
                      },
                      value: _moeda,
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _atualizarPreco();
                      });
                    },
                    style: ButtonStyle(
                      textStyle:
                          MaterialStateProperty.all(TextStyle(fontSize: 18)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                    child: const Text("Atualizar"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
