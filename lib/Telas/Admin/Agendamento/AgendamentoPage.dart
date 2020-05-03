import 'package:autooh/Helpers/DateSelector.dart';
import 'package:autooh/Helpers/Helper.dart';
import 'package:autooh/Helpers/References.dart';
import 'package:autooh/Helpers/Styles.dart';
import 'package:autooh/Objetos/Campanha.dart';
import 'package:autooh/Objetos/Carro.dart';
import 'package:autooh/Objetos/Instalacao.dart';
import 'package:autooh/Objetos/Parceiro.dart';
import 'package:autooh/Objetos/Solicitacao.dart';
import 'package:autooh/Objetos/User.dart';
import 'package:autooh/Telas/Admin/Agendamento/AgendamentoController.dart';
import 'package:autooh/Telas/Admin/TelasAdmin/ParceirosBloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgendamentoPage extends StatefulWidget {

  Instalacao instalacao;
  Parceiro parceiro;
  Campanha campanha;
  String hora_agendada;
  User usuario;
  Carro carro;

  AgendamentoPage({Key key,this.instalacao, this.carro, this.usuario, this.campanha, this.parceiro}) : super(key: key, );

  @override
  _AgendamentoPageState createState() {
    return _AgendamentoPageState();
  }
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  @override
  void initState() {
    super.initState();
    if(ac == null){
      ac = AgendamentoController(instalacao: widget.instalacao);
    }
    if(pc == null){
      pc = new ParceirosBloc(parceiro: widget.parceiro);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
   Parceiro parceiros;
  ParceirosBloc pc;
  AgendamentoController ac;
   DateTime agendamentoIni;
  Instalacao instalacao;
  @override
  Widget build(BuildContext context) {
    BasicDateTimeField agendamentoField = BasicDateTimeField(
        label: 'Agende Sua Instalação', icon: FontAwesomeIcons.solidCalendarPlus);
    var linearGradient = const BoxDecoration(
      gradient: const LinearGradient(
        begin: FractionalOffset.centerRight,
        end: FractionalOffset.bottomLeft,
        colors: <Color>[
          Color(0xFFE8F5E9),
          Color(0xFFE0F7FA),
        ],
      ),
    );
    return Scaffold(

         appBar: myAppBar('Instalação', context),

      body: StreamBuilder<Parceiro>(
          stream: pc.outParceiroSelecionado,
          builder: (context, snapshot) {
         Parceiro parceiros = snapshot.data;
            if(parceiros == null){
              parceiros = new Parceiro();
            }
            if(parceiros ==null){
              return Container(child: Text('erro ao buscar'),);
            }
            return Container(
            decoration:linearGradient ,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Center(
                         child: CircleAvatar(radius: 50,child: parceiros.foto != null
                             ? Image(
                           image: CachedNetworkImageProvider(
                              parceiros.foto),
                         )
                             : Stack(children: <Widget>[
                           Positioned(
                             child: Image(
                                 image: AssetImage(
                                     'assets/campanha_sem_foto.png')),
                           ),

                         ]) ),
                       ),
                     ),sb,
                Padding(
                  padding:  EdgeInsets.only(left: 40.0),
                  child: Row( mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
                     Icon(FontAwesomeIcons.mobileAlt, color: corPrimaria,),sb, hText('Contato: ${parceiros.telefone}',context)

                  ],),
                ),
                 sb,
                Padding(
                  padding:  EdgeInsets.only(left: 40.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                    Icon(FontAwesomeIcons.user, color: corPrimaria,),sb, hText('Nome: ${parceiros.nome}',context)


                  ],),
                ),sb,Divider(color: corPrimaria
                ),sb,
                hText('Horário de funcionamento', context),sb,Divider(color: corPrimaria
                ),sb,

               Padding(
                 padding:  EdgeInsets.only(left: 40.0),
                 child: Row(
                   children: <Widget>[
                     Icon(FontAwesomeIcons.clock, color: corPrimaria),sb,hText('Abre: ${parceiros.hora_ini.hour}:${parceiros.hora_ini.minute}', context),
                   ],
                 ),
               ),sb,
                Padding(
                  padding:  EdgeInsets.only(left: 40.0),
                  child: Row(
                    children: <Widget>[Icon(FontAwesomeIcons.clock, color: corPrimaria),sb,
                      hText('Fecha: ${parceiros.hora_fim.hour}:${parceiros.hora_fim.minute}', context),
                    ],
                  ),
                ),sb,Divider(color: corPrimaria
    ),sb,
    hText('Dias da Semana que Atende', context),sb,Divider(color: corPrimaria
    ),sb,
               Padding(
                 padding:  EdgeInsets.only(left: 40.0),
                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                     Row(children: <Widget>[hText('Segunda: ', context), parceiros.segunda == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                     ,sb,
                   Row(children: <Widget>[hText('Terça: ', context), parceiros.terca == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                    ,sb,
                   Row(children: <Widget>[hText('Quarta: ', context), parceiros.quarta == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                   ,sb,Row(children: <Widget>[hText('Quinta: ', context), parceiros.quinta == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                    ,sb, Row(children: <Widget>[hText('Sexta: ', context), parceiros.sexta == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                   ,sb, Row(children: <Widget>[hText('Sábado: ', context), parceiros.sabado == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )
                     ,sb, Row(children: <Widget>[hText('Domingo: ', context), parceiros.domingo == true? hText('Atende', context, color: Colors.green):hText('Não Atende', context, color: Colors.red)],  )

                 ],),
               ),
                 sb,Divider(color: corPrimaria,),sb,
                hText('Agende seu Dia', context),sb,Divider(color: corPrimaria,),sb,

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<Instalacao>(
                    stream: ac.outInstalacaoSelecionado,
                    builder: (context, snapshot) {
                      Instalacao instalacao = snapshot.data;
                      if(instalacao == null){
                        instalacao = new Instalacao();
                      }
                      if(instalacao == null){
                        return Container(child: hText('Erro ao buscar horarios', context));
                      }
                      return Column(
                        children: <Widget>[
                          agendamentoField,
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                            Container(child: defaultActionButton('Agendar', context, (){


                                  carrosRef.where('dono', isEqualTo: Helper.localUser.id).getDocuments().then((carro){
                                    Carro c= Carro.fromJson(carro.documents[0].data);
                                      solicitacoesRef.where('usuario', isEqualTo: Helper.localUser.id).getDocuments().then((solicitacao){
                                        Solicitacao cc = Solicitacao.fromJson(solicitacao.documents[0].data);

                                        userRef.where('id', isEqualTo: Helper.localUser.id).getDocuments().then((user){
                                           User u = User.fromJson(user.documents[0].data);

                                            Instalacao i = Instalacao(

                                              created_at: DateTime.now(),
                                              hora_agendada: agendamentoField.selectedDate,
                                              id_campanha: cc,
                                              id_carro: c,
                                              id_usuario: u,
                                               id_parceiro: parceiros,
                                                updated_at: DateTime.now()
                                            );

                                            instalacoesRef.add(i.toJson()).then((v){
                                               i.id = v.documentID;
                                               instalacoesRef.document(i.id).updateData(i.toJson()).then((v){
                                                  dToast('Agendamento feito com sucesso!');
                                               });
                                            });
                                        });
                                      });


                              });
                            }, icon: null))

                          ],)
                        ],
                      );


                    }
                  ),
                ), sb,

              ],),
            ),
          );
        }
      ),

    );
  }
}