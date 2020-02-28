import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';

import '../../main.dart';

class TermosPage extends StatefulWidget {
  TermosPage({Key key}) : super(key: key);

  @override
  _TermosPageState createState() {
    return _TermosPageState();
  }
}

class _TermosPageState extends State<TermosPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: myAppBar('Termos e Condições de Uso', context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              sb,
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'TERMOS DE USO DO bocaboca',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              sb,
              sb,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text.rich(
                    TextSpan(
                        text: 'Última Atualização: 28 de dezembro de 2019\n\n',
                        children: [
                          TextSpan(
                            text:
                                'Bem-vindo(a) e obrigado por utilizar o bocaboca!\n\n',
                          ),
                          TextSpan(
                              text:
                                  'Este aplicativo e seu conteúdo ("bocaboca") são controlados e operados pala PROGRAHMA Tecnologia e Serviços Ltda. Todos os direitos reservados.\n\n'),
                          //TextSpan(
                          //    text:
                          //        'Nesse sentido, a presente Política de Privacidade (“'),
                          //TextSpan(
                          //    text: 'Política',
                          //    style: TextStyle(fontWeight: FontWeight.bold)),
                          //TextSpan(
                          //    text:
                          //        '”) explica de maneira clara e acessível como as suas informações e dados serão coletados, usados, compartilhados e armazenados por meio dos nossos sistemas\n\n'),
                          TextSpan(
                              text:
                                  'De acordo com a disposição do artigo 41 da Lei Geral de Proteção de Dados, o bocaboca indica o Sr. Jorge Cardoso, “Data Protection Officer”, como pessoa encarregada pelo tratamento de dados, sendo possível o contato através do seguinte e-mail: jorge.cardoso@prograhma.com.\n\n'),
                          TextSpan(
                              text:
                                  'Estes termos de uso têm por objeto definir as regras a serem seguidas para a utilização do bocaboca ("Termos de Uso"), sem prejuízo da aplicação da legislação vigente.\n\n'),
                          TextSpan(
                              text:
                                  'AO UTILIZAR O bocaboca, VOCÊ AUTOMATICAMENTE CONCORDA COM ESTES TERMOS DE USO QUE CONSTITUEM UM CONTRATO ENTRE NÓS E APLICAM-SE A QUALQUER PESSOA FÍSICA OU JURÍDICA INTERESSADA EM UTILIZAR OS SERVIÇOS, SISTEMAS E APLICATIVOS bocaboca, RESPONSABILIZANDO-SE INTEGRALMENTE POR TODOS E QUAISQUER ATOS PRATICADOS POR VOCÊ NO bocaboca OU EM SERVIÇOS A ELE RELACIONADOS. CASO VOCÊ NÃO CONCORDE COM QUALQUER DOS TERMOS E CONDIÇÕES ABAIXO ESTABELECIDOS, VOCÊ NÃO DEVE UTILIZAR O bocaboca. VOCÊ TAMBÉM CONCORDA COM OS TERMOS DESCRITOS EM NOSSA POLÍTICA DE PRIVACIDADE. PARA ACESSÁ-LA, CLIQUE AQUI (http://www.bocaboca.com/politicadeprivacidade.html).\n\n'),
                          TextSpan(
                              text:
                                  'Caso queira nos dar algum feedback sobre o bocaboca, tenha dúvidas ou precise tratar de qualquer assunto relacionado a estes Termos de Uso, entre em contato conosco através do e-mail nutrinho@bocaboca.com.\n\n'),
                          TextSpan(text: '1.	O que é o bocaboca?\n\n'),
                          TextSpan(
                              text:
                                  '1.1.	Serviços. o bocaboca é uma plataforma que oferece os seguintes serviços: Interação entre Coaches do Bem-Estar (“prestador”) e seus Clientes (“Cliente”). Ambos denominados (“Usuário”).\n\n'),
                          TextSpan(
                              text: '1.2.	Recursos disponíveis ao Cliente.\n'),
                          TextSpan(text: '1.2.1	Cadastro\n'),
                          TextSpan(text: '1.2.2	Perfil\n'),
                          TextSpan(text: '1.2.3	Avaliações\n'),
                          TextSpan(
                              text: '1.2.4	Dados Estatísticos do Progresso\n'),
                          TextSpan(text: '1.2.5	Avatar(IMC)\n'),
                          TextSpan(text: '1.2.6	Localizar Coaches\n'),
                          TextSpan(text: '1.2.7	Resultados\n'),
                          TextSpan(text: '1.2.8	Dicas do dia\n'),
                          TextSpan(text: '1.2.9	Créditos\n'),
                          TextSpan(text: '1.2.10	Produtos\n'),
                          TextSpan(text: '1.2.11	Pedidos\n'),
                          TextSpan(text: '1.2.12	Chat\n'),
                          TextSpan(text: '1.2.13	Formas de Pagamento\n'),
                          TextSpan(text: '1.2.14	Eventos \n\n'),
                          TextSpan(
                              text: '1.3.	Recursos disponíveis ao prestador\n'),
                          TextSpan(text: '1.3.1	Cadastro\n'),
                          TextSpan(text: '1.3.2	Perfil\n'),
                          TextSpan(text: '1.3.3	Avaliações\n'),
                          TextSpan(
                              text: '1.3.4	Dados Estatísticos do Progresso\n'),
                          TextSpan(text: '1.3.5	Avatar (IMC)\n'),
                          TextSpan(text: '1.3.6	Localizar Coaches\n'),
                          TextSpan(text: '1.3.7	Resultados\n'),
                          TextSpan(text: '1.3.8	Dicas do dia\n'),
                          TextSpan(text: '1.3.9	Créditos\n'),
                          TextSpan(text: '1.3.10	Produtos\n'),
                          TextSpan(text: '1.3.11	Pedidos\n'),
                          TextSpan(text: '1.3.12	Chat\n'),
                          TextSpan(text: '1.3.13	Formas de Pagamento\n'),
                          TextSpan(text: '1.3.14	Eventos\n'),
                          TextSpan(text: '1.3.15	Plano de Assinatura\n'),
                          TextSpan(
                              text: '1.3.16	Dados Estatísticos do Negócio\n'),
                          TextSpan(text: '1.3.17	Controle de Estoque\n'),
                          TextSpan(
                              text:
                                  '1.3.18	Migração de Clientes do EHN para outro prestador\n\n'),
                          TextSpan(
                              text:
                                  '1.4.	Suspensão. Nós nos reservamos o direito de suspender ou cancelar, a qualquer momento, o seu acesso à aplicação em caso de suspeita de fraude, obtenção de benefício ou vantagem de forma ilícita, ou pelo não cumprimento de quaisquer condições previstas nestes Termos de Uso, na Política de Privacidade ou na legislação aplicável. Nesses casos, não será devida qualquer indenização a você, e o bocaboca poderá promover a competente ação de regresso, se necessário, bem como tomar quaisquer outras medidas necessárias para perseguir e resguardar seus interesses. \n\n'),
                          TextSpan(text: '2.	Como acesso o bocaboca? \n\n'),
                          TextSpan(
                              text:
                                  '2.1.	Acesso. O bocaboca estará disponível para download pelas lojas de aplicativos Apple Store (iOS) e Google Play (Android). \n'),
                          TextSpan(
                              text:
                                  '2.2.	Opções de Cadastro. Para cadastrar após download o bocaboca perguntará se você é um prestador do Bem-Estar (“prestador”) ou Cliente(“Cliente”). \n'),
                          TextSpan(
                              text:
                                  '2.3.	Cadastro de prestador. O prestador terá 07 (sete) dias corridos para uso do aplicativo gratuitamente. A partir do 8º dia corrido após cadastro, o prestador será consultado para saber se deseja continuar utilizando o aplicativo. Caso seja sua vontade, o prestador fornecerá informações de preferência de pagamento e selecionará o Plano Pago de Assinatura para ingressar. Para saber mais sobre a privacidade de suas informações pessoais no bocaboca, acesse nossa Política de Privacidade. \n'),
                          TextSpan(
                              text:
                                  '2.4.	Cadastro de Cliente. O Cliente, geralmente indicado por um prestador, ao selecionar como perfil de Cliente, informará seus dados de cadastro e automaticamente seu plano será o Gratuito. Para saber mais sobre a privacidade de suas informações pessoais no bocaboca, acesse nossa Política de Privacidade. \n'),
                          TextSpan(
                              text:
                                  '2.5.	Cadastro de Endereço. O bocaboca permitirá o cadastro do endereço de residência do Usuário, e no caso de prestador, endereço comercial, quando possuir. Ao selecionar um endereço comercial, o prestador autoriza que ele seja utilizado para ser localizado pelos Clientes do grupo.\n'),
                          TextSpan(
                              text:
                                  '2.6. Idade de Utilização. Para utilizar o bocaboca, você deve ter, pelo menos, 18 anos. No caso de menores de idade, com idade mínima de 16 anos, solicitamos que o cadastro seja feito sob autorização dos pais ou responsável legal.\n'),
                          TextSpan(
                              text:
                                  '2.7.	Titularidade. A partir do cadastro, você será titular de uma conta que somente poderá ser acessada por você, em até 2 (dois) dispositivos (“Devices”). Caso o bocaboca detecte alguma conta feita a partir de informações falsas, por Usuários que, por exemplo, não possuem a idade mínima permitida, essa conta será automaticamente apagada. \n'),
                          TextSpan(
                              text:
                                  '2.8.	Atualização das Informações. Desde já, você se compromete a manter as suas informações pessoais atualizadas. Você também concorda que irá manter o seu login e senha seguros e fora do alcance de terceiros, e não permitirá que a sua conta no bocaboca seja usada por outras pessoas. Dessa forma, o Usuário responsabiliza-se por todas as ações realizadas em sua conta. \n'),
                          TextSpan(
                              text:
                                  '2.9.	Conexão via Terceiros. Alternativamente, o bocaboca poderá te oferecer a possibilidade de realizar seu cadastro por meio de sua conta de serviços de terceiros como Facebook e Google, mas não apenas estes. Nessa hipótese, você autoriza o bocaboca a acessar, armazenar e utilizar as informações fornecidas por terceiros a fim de criar a sua conta no bocaboca. O bocaboca NÃO tem qualquer ligação com esses terceiros, não possuindo qualquer responsabilidade, tampouco garantindo, em qualquer hipótese, os produtos ou serviços fornecidos por eles. \n\n'),
                          TextSpan(
                              text:
                                  '3.	A relação contratual entre o bocaboca e o Usuário\n'),
                          TextSpan(
                              text:
                                  '3.1.	Relação Contratual. Os serviços e o conteúdo oferecidos pela plataforma são propriedade do bocaboca. Ao estabelecer o contrato que permite ao Usuário o gozo das funcionalidades do sistema, o bocaboca está oferecendo uma licença de uso, que é não-exclusiva, limitada, revogável e de uso pessoal. É da liberalidade do Usuário subscrever a qualquer plano oferecido pelo bocaboca, sujeito às regras descritas nesses Termos de Uso. \n'),
                          TextSpan(
                              text:
                                  '3.2.	Compra de Produtos bocaboca. Somado ao oferecimento da subscrição aos planos do bocaboca, nossa plataforma permitirá a compra de produtos para o uso do Usuário dentro da plataforma. A compra desses produtos estará sujeita às regras de licenciamento, dispostas na plataforma e/ou nesses Termos de Uso. Caso tais produtos envolvam a integração com plataformas de terceiros, o Usuário também estará sujeito aos Termos de Uso, Política de Privacidade e Especificações de Segurança de tal terceiro. \n'),
                          TextSpan(
                              text:
                                  '3.3.	Compra de Produtos e Serviços do prestador. O aplicativo bocaboca disponibiliza uma interação entre o prestador do Bem-Estar e seus Clientes. Estes Produtos e Serviços, assim como o recebimento e confirmação de entrega ao Cliente, são de responsabilidade do prestador. O bocaboca é um aplicativo que provê ao prestador a possibilidade de interagir com seus Clientes, vender seus produtos e serviços, sendo o bocaboca, um facilitador que coloca o prestador em contato com tecnologias de meios de pagamento e ajuda os Clientes do prestador a terem informações online sobre suas avaliações e uso dos produtos oferecidos pelos Coaches.\n\n'),
                          TextSpan(
                              text:
                                  '4.	Assinatura e Cancelamento de Planos de Assinatura\n'),
                          TextSpan(
                              text:
                                  '4.1.	Assinatura. Nós do bocaboca fornecemos a assinatura de planos de serviço da seguinte maneira: gratuita e onerosa, como definido nos capítulos abaixo. \n'),
                          TextSpan(
                              text:
                                  '4.2.	Modo de Subscrição Gratuita. A subscrição ao plano gratuito não requer pagamento para uso do aplicativo bocaboca e é o modo de subscrição sugerida ao Cliente. O bocaboca na modalidade de subscrição gratuita não possui todas as features do modo de subscrição onerosa, mas possui todas as features que um Cliente precisa.\n'),
                          TextSpan(
                              text:
                                  '4.3.	Modo de Subscrição Onerosa. A subscrição ao(s) plano(s) pago(s) requer o pagamento antecipado para a subscrição ao plano. Dessa forma, você estará pagando hoje pelo acesso ao aplicativo durante o período de recorrência do plano de assinatura escolhido (mensal ou anual). Haverá renovação automática do plano de assinatura, a não ser que você se manifeste contrariamente requerendo o cancelamento do plano de assinatura, antes da data de faturamento da recorrência.\n'),
                          TextSpan(
                              text:
                                  '4.4.	Cancelamento da Subscrição. O cancelamento da subscrição ao plano pode ser realizado a qualquer tempo pelo prestador e será entendido como manifestação expressa de que não pretende renovar a licença no próximo período ainda não contabilizado para fins de cobrança. O cancelamento não enseja qualquer dever ao bocaboca de realizar a devolução do pagamento do período no qual o prestador optou por não renovar a relação contratual. Ao optar pelo cancelamento da subscrição onerosa, o prestador perde as caraterísticas do plano pago de assinatura, e caso decida em continuar o uso como prestador, deverá refazer sua subscrição. \n'),
                          TextSpan(
                              text:
                                  '4.5.	In-App Purchases. A aplicação possui funcionalidades que podem ser compradas dentro da plataforma, as chamadas “In-App Purchases”. As eventuais compras desses serviços ocorrerão de maneira semelhante ao disposto acima. \n'),
                          TextSpan(
                              text:
                                  '4.6.	Taxas de Uso de Meios de Pagamentos. O prestador é responsável por configurar o bocaboca em sua tela específica de Perfil e informar ao aplicativo se ele deverá ou não repassar aos seus Clientes, a cobrança de taxas por financiamento de valores a serem pagos pela compra de produtos e serviços. Também é de responsabilidade do prestador, informar ao Cliente no momento da compra que estes valores serão repassados a ele. As taxas cobradas pelos Meios de Pagamento podem mudar de acordo com a operação e com a vigência do contrato, promoções e acordos comerciais.\n'),
                          TextSpan(
                              text:
                                  '4.7.	Taxas de Uso do bocaboca para compra de produtos e serviços. Caso o prestador configure o bocaboca para ser utilizado como intermediário tecnológico entre ele para conexão com os meios de pagamentos, uma taxa adicional de 0,80% será acrescida à transação.\n\n'),
                          TextSpan(
                              text:
                                  '5.	Como são feitos os pagamentos no bocaboca? \n'),
                          TextSpan(
                              text:
                                  '5.1.	Meio de Pagamento de Assinatura do bocaboca. Os pagamentos efetuados de subscrição de plano(s) pago(s) de uso do bocaboca deverão ser realizados dentro da aplicação, por meio de cartão de crédito, débito, vouchers e boleto bancário. \n'),
                          TextSpan(
                              text:
                                  '5.2. Meio de Pagamento de Compra de Produtos. Os pagamentos efetuados por Clientes para compra de produtos e serviços oferecidos pelo prestador deverão ser realizados dentro da aplicação, por meio de Cartão de Crédito, Débito, Vouchers e Boletos Bancários, salvo se o prestador configurar o aplicativo para que o bocaboca Não seja o meio utilizado para controle de pagamentos. Caso o prestador opte por não usar o aplicativo bocaboca como interação entre ele, o Meio de Pagamento e o Cliente, ele será responsável direto pelo recebimento junto aos seus Clientes. \n'),
                          TextSpan(
                              text:
                                  '5.3.	Preço Final de Assinatura ao bocaboca. O preço pago pelo prestador pela assinatura de plano(s) pago(s) é final e não reembolsável, a menos que diversamente determinado pelo bocaboca. O bocaboca reserva-se o direito de estabelecer, remover e/ou revisar o preço relativo a todos os serviços ou bens obtidos por meio do uso da aplicação a qualquer momento. Nunca alteraremos o valor da sua subscrição sem antes avisá-lo. \n'),
                          TextSpan(
                              text:
                                  '5.4.	Preço Final de Compra de Produtos. O preço pago pelo Cliente ao prestador por compra de produtos e serviços é reembolsável, desde que seja seguido o código de defesa do consumidor (“CDC”). Cabe ao Cliente contatar diretamente o prestador e iniciar as tratativas de troca e/ou devolução de produtos. Neste caso, o bocaboca não tem qualquer responsabilidade ou controle sobre as operações feitas fora do aplicativo (ou qualquer outra atividade não atendida ou registrada no aplicativo) entre Cliente e prestador já que o prestador é o responsável pelo contato com seus Clientes e tratativas para garantir o melhor atendimento possível. Caberá ainda, ao prestador, estabelecer o contato com o fabricante dos produtos e negociar, ainda dentro do CDC, a melhor maneira de ressarcir ou trocar os produtos reclamados pelo Cliente, caso parta do Cliente o desejo expresso de devolver um ou todos os produtos adquiridos, respeitando obviamente as regras do CDC.\n'),
                          TextSpan(
                              text:
                                  '5.5.	Recolhimento de Impostos. Se houver a incidência de qualquer imposto, o Usuário será responsável por seu recolhimento. Em caso de eventual recolhimento por parte da aplicação, a mesma explicita que repassará ao prestador no preço. \n'),
                          TextSpan(
                              text:
                                  '5.6.	Confirmação. A confirmação do pagamento por meio da aplicação ocorrerá em até 3 (três) dias úteis. O processamento das informações de pagamento e a confirmação do pagamento serão realizados por sistemas de terceiros (ex. instituição financeira ou administradora do cartão de crédito), sendo o aplicativo uma mera interface entre o Cliente e esses sistemas. \n'),
                          TextSpan(
                              text:
                                  '5.7.	Prazo mínimo. Certos produtos ou promoções do bocaboca podem exigir um prazo mínimo de assinatura. É importante que o prestador esteja ciente de que, caso decida não utilizar mais tais produtos antes do prazo mínimo de assinatura, podem ser cobradas tarifas adicionais. \n'),
                          TextSpan(
                              text:
                                  '5.8.	Código Promocional. Caso o bocaboca crie algum código promocional (por exemplo, cupom de desconto), este deve ser usado de forma legal para a finalidade e o público ou Usuário específico a que se destina, seguindo todas suas condições. O código promocional pode ser cancelado caso se verifique que foi transferido, vendido ou utilizado com erro, fraude, ilegalidade ou violação às condições do respectivo código. O código promocional é único por operação, uma vez utilizado, ele perde sua validade.\n\n'),
                          TextSpan(
                              text:
                                  '6. Quais são os direitos do bocaboca sobre o aplicativo? \n'),
                          TextSpan(
                              text:
                                  '6.1. Nossos Direitos. Todos os direitos relativos ao bocaboca e suas funcionalidades são de propriedade exclusiva do bocaboca, inclusive no que diz respeito aos seus textos, imagens, layouts, software, códigos, bases de dados, gráficos, artigos, fotografias e demais conteúdos produzidos direta ou indiretamente pelo bocaboca ("Conteúdo do bocaboca").'),
                          TextSpan(
                              text:
                                  'O Conteúdo do bocaboca é protegido pela lei de direitos autorais e de propriedade intelectual. É proibido usar, copiar, reproduzir, modificar, traduzir, publicar, transmitir, distribuir, executar, fazer o upload, exibir, licenciar, vender ou explorar e fazer engenharia reversa do Conteúdo do bocaboca, para qualquer finalidade, sem o consentimento prévio e expresso do bocaboca. Qualquer uso não autorizado do Conteúdo do bocaboca será considerado como violação dos direitos autorais e de propriedade intelectual do bocaboca. \n\n'),
                          TextSpan(
                              text:
                                  '7. Propriedade intelectual sobre o software e os materiais disponibilizados \n'),
                          TextSpan(
                              text:
                                  '7.1. Propriedade intelectual. Para nós do bocaboca, a qualidade dos materiais disponibilizados ao Usuário é de suma importância. A criação deles é fruto de muito trabalho e dedicação de nossos desenvolvedores. Por isso, reafirmamos que o bocaboca garante que todos os direitos, título e interesse (incluindo, mas não apenas, os direitos autorais, marcários e outros de propriedade intelectual) sobre o serviço disponibilizado por nós permanecerão sob a titularidade do bocaboca. \n'),
                          TextSpan(
                              text:
                                  '7.2. Não-aquisição de Direitos. O Usuário não adquirirá nenhum direito de propriedade sobre os serviços e conteúdos do bocaboca, exceto quando haja outorga expressa neste Termos de Uso. \n'),
                          TextSpan(
                              text:
                                  '7.3. Download de Conteúdo. É proibido que o Usuário faça o download de nosso conteúdo com o intuito de armazená-lo em banco de dados para oferecer para terceiro que não seja o próprio Usuário. Veda-se, também, que o conteúdo disponibilizado por nós seja usado para criar uma base de dados ou um serviço que possa concorrer de qualquer maneira com o nosso negócio. \n\n'),
                          TextSpan(
                              text:
                                  '8. Reclamações sobre violação de direito autoral\n'),
                          TextSpan(
                              text:
                                  '8.1. Infringência de Direitos. Alegações de infringência de direito autoral de qualquer conteúdo disponível do bocaboca devem ser encaminhadas por meio do e-mail nutrinho@bocaboca.com. \n\n'),
                          TextSpan(
                              text:
                                  '9. Responsabilidades do Usuário e do bocaboca \n'),
                          TextSpan(
                              text:
                                  '9.1. Responsabilidade pelo Uso. Você é exclusivamente responsável pelo uso do bocaboca e deverá respeitar as regras destes Termos de Uso, bem como a legislação aplicável ao bocaboca. \n'),
                          TextSpan(
                              text:
                                  '9.2. Responsabilização por Eventuais Danos. O bocaboca, seu controlador, suas afiliadas, parceiras ou funcionários não serão, em hipótese alguma, responsabilizados por danos diretos ou indiretos que resultem de, ou que tenham relação com o acesso, uso ou a incapacidade de acessar ou utilizar o bocaboca. \n'),
                          TextSpan(
                              text:
                                  '9.3. Responsabilização pela Entrega de produtos vendidos pelos Coaches. O prestador é o responsável pela entrega dos produtos comercializados por ele para seus Clientes. O bocaboca é apenas um facilitador técnico entre o prestador e seus Cleintes, disponibilizando tecnologia e meios de pagamentos para que o prestador do Bem-Estar possa comercializar seus produtos e serviços. \n'),
                          TextSpan(
                              text:
                                  '9.4. Não-Responsabilização. TENDO EM VISTA AS CARACTERÍSTICAS INERENTES AO AMBIENTE DA INTERNET, O bocaboca NÃO SE RESPONSABILIZA POR INTERRUPÇÕES OU SUSPENSÕES DE CONEXÃO, TRANSMISSÕES DE COMPUTADOR INCOMPLETAS OU QUE FALHEM, BEM COMO POR FALHA TÉCNICA DE QUALQUER TIPO, INCLUINDO, MAS NÃO SE LIMITANDO, AO MAU FUNCIONAMENTO ELETRÔNICO DE QUALQUER REDE, HARDWARE OU SOFTWARE. A INDISPONIBILIDADE DE ACESSO À INTERNET OU AO bocaboca, ASSIM COMO QUALQUER INFORMAÇÃO INCORRETA OU INCOMPLETA SOBRE O bocaboca, ASSIM COMO QUALQUER FALHA HUMANA, TÉCNICA OU DE QUALQUER OUTRO TIPO NO PROCESSAMENTO DAS INFORMAÇÕES DO bocaboca NÃO SERÃO CONSIDERADAS RESPONSABILIDADE DO bocaboca, O bocaboca SE EXIME DE QUALQUER RESPONSABILIDADES PROVENIENTE DE TAIS FATOS E/OU ATOS. \n'),
                          TextSpan(
                              text:
                                  '9.5. Perda de Lucros. Quando permitido por lei, o bocaboca e os fornecedores ou distribuidores não serão responsáveis por perda de lucros, perda de receita, perda de dados, perdas financeiras ou por danos indiretos, especiais, consequenciais, exemplares ou punitivos. \n'),
                          TextSpan(
                              text:
                                  '9.6. Manutenção. É de sua inteira responsabilidade manter o ambiente de seu dispositivo (computador, celular, tablet, ou outro device utilizado para acessar o bocaboca) seguro, com o uso de ferramentas disponíveis, como antivírus, firewall, entre outras, de modo a contribuir na prevenção de riscos eletrônicos. \n'),
                          TextSpan(
                              text:
                                  '9.7. Links Externos. É possível que o bocaboca possa conter links para sites e aplicativos de terceiros, assim como ter tecnologias integradas. Isso não implica, de maneira alguma, que o bocaboca endossa, verifica, garante ou possui qualquer ligação com os proprietários desses sites ou aplicativos, não sendo responsável pelo conteúdo de terceiros, precisão, políticas, práticas ou opiniões. O bocaboca recomenda que você leia os Termos de Uso e Política de Privacidade de cada site de terceiros ou serviço que o Usuário vier a visitar ou utilizar. \n'),
                          TextSpan(
                              text:
                                  '9.8. Exclusão de Responsabilidade. Quando o bocaboca facilita a interação de você com Prestadores Terceiros independentes, como Coaches do Bem-Estar, isso não significa que o bocaboca endossa, verifica, garante ou possui qualquer ligação ou recomenda esses terceiros. NESSAS SITUAÇÕES, O bocaboca ATUA COMO MERO FACILITADOR DA TRANSAÇÃO ENTRE VOCÊ E TAIS TERCEIROS, DE MODO QUE O bocaboca NÃO É FORNECEDOR DE BENS E SERVIÇOS, OS QUAIS SÃO PRESTADOS DIRETAMENTE POR TERCEIROS PRESTADORES INDEPENDENTES. O bocaboca NÃO SERÁ, EM HIPÓTESE ALGUMA, RESPONSÁVEL POR TAIS PRODUTOS OU SERVIÇOS DE TERCEIROS FORNECEDORES E REITERAMOS A NECESSIDADE DO USUÁRIO LER, ANALISAR E ACEITAR OS TERMOS DE USO DAS PLATAFORMAS QUE POSSAM TER ALGUMA INTERFACE CONOSCO. \n\n'),
                          TextSpan(
                              text:
                                  '10. Como o bocaboca lida com o conteúdo produzido dentro do aplicativo? \n'),
                          TextSpan(
                              text:
                                  '10.1. Criação de Conteúdo. O bocaboca poderá, a seu exclusivo critério, permitir que você ou qualquer outro Usuário apresente, carregue, publique ou disponibilize, na aplicação, conteúdo ou informações de texto, imagem, áudio ou vídeo ("Conteúdo de Usuário"). \n'),
                          TextSpan(
                              text:
                                  '10.2. Conteúdos Proibidos. É proibido qualquer Conteúdo de Usuário de caráter difamatório, calunioso, injurioso, violento, pornográfico, obsceno, ofensivo ou ilícito, conforme apuração do bocaboca a seu critério exclusivo, inclusive informações de propriedade exclusiva pertencentes a outras pessoas ou empresas (ex.: direito de autor, marcas), sem a expressa autorização do titular desses direitos, cuja violação não será de responsabilidade do bocaboca. \n'),
                          TextSpan(
                              text:
                                  '10.3. Titularidade do Conteúdo. Qualquer Conteúdo de Usuário fornecido por você permanece de sua propriedade. Contudo, ao fornecê-lo para o bocaboca, você nos outorga uma licença em nível mundial, por prazo indeterminado, gratuita e transferível, e com direito a sublicenciar, usar, copiar, modificar, criar obras derivadas, distribuir, publicar, exibir esse Conteúdo de Usuário em todos os formatos e canais de distribuição possíveis, sem necessidade de novo aviso a você, e sem necessidade de qualquer pagamento, desde que isso esteja relacionado ao funcionamento da plataforma. Ademais, todas as informações armazenadas em banco de dados são protegidos por criptografia, o que significa que nós seremos "cegos" com relação a esse Conteúdo de Usuário. \n'),
                          TextSpan(
                              text:
                                  '10.4. Exclusão do Conteúdo. O bocaboca poderá, mas não se obriga a analisar, monitorar e remover Conteúdo de Usuário, a critério exclusivo do bocaboca, a qualquer momento e por qualquer motivo, sem nenhum aviso ao Usuário. Solicitações de exclusão de dados poderão ser feitos à qualquer hora, configurando como cancelamento do plano atual vigente. A exclusão de dados não gerará qulaquer ônus ao Usuário solicitante, mas o bocaboca se reserva do direito de manter os dados referentes à movimentações financeiras e quaisquer outras informações exigidas por lei. \n\n'),
                          TextSpan(
                              text:
                                  '11. O que mais eu preciso saber sobre estes Termos de Uso? \n'),
                          TextSpan(
                              text:
                                  '11.1. Alterações. Para melhorar sua experiência, o bocaboca está sempre sendo atualizado. Por esse motivo, estes Termos de Uso podem ser alterados, a qualquer tempo, a fim de refletir os ajustes realizados. No entanto, sempre que ocorrer qualquer modificação, você será previamente informado pelo endereço de e-mail fornecido por você no momento do cadastro ou por um aviso em destaque na aplicação. Caso você não concorde com os novos Termos de Uso, você poderá rejeitá-los, mas ao fazê-lo integralmente, infelizmente isso significará que você não concorda e recomendaremos que você não tenha mais acesso ou faça uso do bocaboca. Se de qualquer maneira você utilizar o Nutrano mesmo após a alteração destes Termos de Uso, isso significa que você concordará com todas as modificações. \n'),
                          TextSpan(
                              text:
                                  '11.2. Conflito entre Disposições. Em caso de conflito entre estes Termos de Uso e os Termos de Uso modificados, os termos posteriores prevalecerão com relação a esse conflito. \n'),
                          TextSpan(
                              text:
                                  '11.3. Lei e Foro. Ests Termos de Uso são regidos pelas leis da República Federativa do Brasil. Quaisquer dúvidas e situações não previstas nestes Termos de Uso serão primeiramente resolvidas pelo bocaboca e, caso persistam, deverão ser solucionadas pelo Foro da Comarca de São Paulo, São Paulo, com exclusão de qualquer outro, por mais privilegiado que seja ou venha a ser. \n'),
                          TextSpan(
                              text:
                                  '11.4. Dúvidas. Caso você tenha alguma dúvida, comentário ou sugestão, por favor, entre em contato conosco por meio do e-mail nutrinho@bocaboca.com, um canal próprio para este fim.'),
                        ]),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
