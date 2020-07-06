import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {

    final caminhoBancoDados = await getDatabasesPath(); // recupera o caminho para o banco de dados
    final localBancoDados = join(caminhoBancoDados, 'banco.db');

    var dados = await openDatabase(
      localBancoDados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = 'CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, idade INTEGER)';
        db.execute(sql);
      }
    );
    return dados;
    //print('aberto ' + bd.isOpen.toString());
  }

  _salvar() async {

    Database dados =  await _recuperarBancoDados();

    Map<String, dynamic> dadosUsuario = {
      'nome' : 'leo',
      'idade' : 1,
    };
    int id = await dados.insert('usuarios', dadosUsuario);
    print('salvo : $id');
  }

  _listarUsuarios() async {

    Database dados =  await _recuperarBancoDados();

    //String sql = 'SELECT *, UPPER(nome) as nomeMaiu FROM usuarios WHERE 1=1 ORDER idade DESC LIMIT 31';
    String sql = 'SELECT * FROM usuarios';
    List usuarios = await dados.rawQuery(sql);

    for( var usuario in usuarios ){
      print(
        'item id:' + usuario['id'].toString() +
          'nome: ' + usuario['nome'] +
          'idade: ' + usuario['idade'].toString()
      );
    }
    //print('usuarios: ' + usuarios.toString());
  }

  _recuperarUsarioPeloId(int id) async {

  Database dados = await _recuperarBancoDados();

  List usuarios = await dados.query(
    'usuarios',
    columns: ['id', 'nome', 'idade'],
    where: 'id = ?',
    whereArgs: [id]
  );

  for( var usuario in usuarios ){
    print(
            'item id:' + usuario['id'].toString() +
            'nome: ' + usuario['nome'] +
            'idade: ' + usuario['idade'].toString()
    );
  }}

  _excluirUsuario(int id) async {
    Database dados = await _recuperarBancoDados();

    int retorno = await dados.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id]
    );

    print('item qtde removida: $retorno');
  }

  @override
  Widget build(BuildContext context) {

    //_salvar();
    //_listarUsuarios();
    //_recuperarUsarioPeloId(2);
    _excluirUsuario(2);


    return Scaffold(

    );
  }
}
