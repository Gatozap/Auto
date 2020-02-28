import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference userRef = Firestore.instance.collection('Users').reference();
CollectionReference chatRef = Firestore.instance.collection('Chats').reference();
CollectionReference notificacoesRef = Firestore.instance.collection('Notificacoes').reference();
CollectionReference gruposRef = Firestore.instance.collection('Grupo').reference();

CollectionReference personagensRef =
    Firestore.instance.collection('Personagens').reference();


CollectionReference carrosRef =
Firestore.instance.collection('Carro').reference();

CollectionReference periciasRef =
    Firestore.instance.collection('Pericias').reference();

CollectionReference talentosRef =
    Firestore.instance.collection('Talentos').reference();

CollectionReference equipamentosRef =
Firestore.instance.collection('Equipamentos').reference();


CollectionReference prestadorRef =
Firestore.instance.collection('Prestadores').reference();

CollectionReference tabuleirosRef =
Firestore.instance.collection('Tabuleiros').reference();
CollectionReference produtosRef =
Firestore.instance.collection('Produtos').reference();
CollectionReference pagamentoRef =
Firestore.instance.collection('Pagamentos').reference();
CollectionReference despesasRef =
Firestore.instance.collection('Despesas').reference();
CollectionReference comandasRef =
Firestore.instance.collection('Comandas').reference();
CollectionReference estoquesRef =
Firestore.instance.collection('Estoques').reference();
CollectionReference pacotesRef =
Firestore.instance.collection('Pacotes').reference();
CollectionReference carteirasRef =
Firestore.instance.collection('Carteiras').reference();
CollectionReference vendedoresRef =
Firestore.instance.collection('Vendedores').reference();
