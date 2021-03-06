import 'package:flutter/material.dart';
import 'package:gerenciadorgastospessoais/screens/components/card_conta.dart';
import 'package:gerenciadorgastospessoais/screens/components/card_transacao.dart';
import 'package:gerenciadorgastospessoais/screens/transacao/transacao_screen.dart';
import 'package:gerenciadorgastospessoais/services/conta_service.dart';
import 'package:gerenciadorgastospessoais/services/transacao_service.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ContaService cs = ContaService();
  TransacaoService ts = TransacaoService();
  late Future<List> _loadContas;
  late Future<List> _loadTransacoes;
  late List _contas;
  late List _transacoes;

  @override
  void initState() {
    // TODO: implement initState
    _loadContas = _getContas();
    _loadTransacoes = _getTransacoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 175,
            child: FutureBuilder(
              future: _loadContas,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _contas = snapshot.data;
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _contas.length,
                      padding: EdgeInsets.only(left: 16, right: 8),
                      itemBuilder: (context, index) {
                        return cardConta(context, _contas[index]);
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, top: 32, bottom: 16, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "??ltimas transa????es",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => TransacaoScreen()
                        )
                    );
                  },
                  child: Text(
                    "Ver todas",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue),
                  ),
                )
              ],
            ),
          ),
          FutureBuilder(
              future: _loadTransacoes,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  _transacoes = snapshot.data;
                  return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _transacoes.length > 6 ? 6 : _transacoes.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                          return cardTransacao(context, index, _transacoes[index]);
                          }
                      ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
              ),
        ],
      ),
    );
  }

  Future<List> _getContas() async {
    return await cs.getAllConta();
  }

  Future<List> _getTransacoes() async {
    return await ts.getAllTransacoes();
  }
}
