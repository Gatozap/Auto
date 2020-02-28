import 'package:flutter/material.dart';
import 'package:bocaboca/Helpers/Helper.dart';

import '../../main.dart';

class PoliticaPage extends StatefulWidget {
  PoliticaPage({Key key}) : super(key: key);

  @override
  _PoliticaPageState createState() {
    return _PoliticaPageState();
  }
}

class _PoliticaPageState extends State<PoliticaPage> {
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
        appBar: myAppBar('Política de Privacidade', context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              sb,
              Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'POLÍTICA DE PRIVACIDADE DO bocaboca',
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
                                  'Quando você utiliza o bocaboca, você nos confia seus dados e informações. Nos comprometemos a manter essa confiança.\n'),
                          TextSpan(
                              text:
                                  'Nesse sentido, a presente Política de Privacidade ("Política") explica de maneira clara e acessívfel como as suas informações e dados serão coletados, usados, compartilhados e armazenados por meio dos nossos sistemas.\n'),
                          TextSpan(
                              text:
                                  'A aceitação da nossa Política será feita quando você acessar ou usar o site, aplicativo ou serviços do bocaboca. Isso indicará que você está ciente e em total acordo com a forma como utilizaremos as suas informações e seus dados.\n'),
                          TextSpan(
                              text:
                                  'O bocaboca é uma plataforma que oferece os seguintes serviços: Interação entre Coaches do Bem-Estar ("prestador") e seus Cleintes ("Cliente"). Ambos denominados ("Usuário").\n'),
                          TextSpan(
                              text:
                                  'A presente Política está dividida da seguinte forma para facilitar a sua compreensão:\n\n'),
                          TextSpan(
                              text:
                                  '1. Quais informações o bocaboca coleta.\n'),
                          TextSpan(
                              text:
                                  '2. Como o bocaboca usa as informações coletadas.\n'),
                          TextSpan(
                              text:
                                  '3. Como, quando e com quem o bocaboca compartilha suas informações.\n'),
                          TextSpan(
                              text:
                                  '4. Como o bocaboca protege suas informações.\n'),
                          TextSpan(
                              text:
                                  '5. Atualizações dessa Política de Privacidade.\n'),
                          TextSpan(text: '6. Lei aplicável.\n\n'),
                          TextSpan(
                              text:
                                  'Este documento deve ser lido em conjunto com os nossos Termos de Uso (https://www.bocaboca.com/termosdeuso) que contém uma visão geral da nossa plataforma. Caso tenha dúvidas ou precise tratar de qualquer assunto relacionado a esta Política, entre em contato conosco através do e-mail nutrinho@bocaboca.com.\n\n'),
                          TextSpan(text: '1. INFORMAÇÕES QUE COLETAMOS.\n\n'),
                          TextSpan(
                              text:
                                  'Nós coletamos os seguintes tipos de informações:\n'),
                          TextSpan(
                              text:
                                  'Dados de cadastro. Quando você se cadastra no bocaboca, você nos fornece informações como Login, Senha, Nome, Endereço, Endereço de e-mail, CPF/CNPJ, Data de nascimento/fundação, Número do telefone, Foto, Idade, Gênero, Peso, Gordura Corporal, Gordura Visceral, IMC (Índice de Massa Corpórea), Músculos Esqueléticos, Medidas do seu corpo (Cintura, Abdômen, Quadril, Coxa, Braço, Relação Cintura-Quadril) e ID).\n'),
                          TextSpan(
                              text:
                                  'Conexão por serviços de terceiros. Quando você se conecta ou faz login no bocaboca com serviços de terceiros (por exemplo, Facebook, Google e Apple), poderemos coletar os dados que você nos fornece através desses serviços, como nome, endereço de e-mail, descrição do perfil, foto do perfil. Neste caso, respeitamos as suas configurações de privacidade e estes dados dependem de como o Usuário configura estes serviços de terceiros, chamados também de mídias sociais.\n'),
                          TextSpan(
                              text:
                                  'Informações de autenticação. Para lhe proporcionar um ambiente seguro, podemos pedir que você nos forneça informações de identificação que por padrão serão baseadas em nome e senha. Por uma comodidade ao Usuário, pode ser utilizada alguma rede social (por exemplo, Facebook, Google e Apple), ou outras informações de autenticação (por exemplo, via SMS ou e-mail) para facilitar a autenticação ao aplicativo bocaboca. Autenticação por redes sociais trata-se de uma comodidade ao Usuário, sendo assim, é opcional e cabe ao Usuário decidir qual a melhor forma para se autenticar no aplicativo.\n'),
                          TextSpan(
                              text:
                                  'Outras informações fornecidas. Ao utilizar recursos pagos do bocaboca, você pode nos fornecer informações como Forma de Pagamento.\n\n'),
                          TextSpan(
                              text:
                                  '1.1. Informações geradas quando você usa nossos serviços.\n\n'),
                          TextSpan(
                              text:
                                  'Nós coletamos as seguintes informações geradas:\n'),
                          TextSpan(
                              text:
                                  'Registros de acesso. O bocaboca coleta automaticamente registros de acesso a aplicação, que incluem o endereço de IP, com data e hora, utilizado para acessar o bocaboca. Esses dados são de coleta obrigatória, de acordo com a Lei 12.965/2014, mas somente serão fornecidos para terceiros com a sua autorização expressa ou por meio de demanda judicial.\n'),
                          TextSpan(
                              text:
                                  'Dados de uso. Nós coletamos informações sobre suas interações no bocaboca, como sua navegação, as páginas ou outro conteúdo que você acessa ou cria, suas buscas, participações em pesquisas ou fóruns e outras ações.\n'),
                          TextSpan(
                              text:
                                  'Dados de localização do dispositivo conectado. Nós coletamos dados de localização, que são coletados através do seu equipamento ou dispositivo conectado, caso você autorize, mediante mensagem que aparece no seu dispositivo, de forma padrão e dependendo do fabricante do dispositivo. A sua autorização para compartilhar a sua localização poderá ser revogada a qualquer momento, diretamente em seu dispositivo móvel, na sessão e configurações, não só para o bocaboca, mas para todos os aplicativos que façam uso de geolocalização. No entanto, ao fazê-lo, o Usuário estará ciente que algumas funcionalidades da plataforma estarão inativas.\n'),
                          TextSpan(
                              text:
                                  'Dados de pagamento. Quando você realiza pagamento no bocaboca, poderão ser armazenados dados do pagamento, como a data e horas, o valor e outros detalhes da transação, que poderão ser utilizados inclusive para fins de prevenção à fraude. Desta forma, poderemos lhe proporcionar um ambiente seguro e adequado para você realizar suas transações.\n'),
                          TextSpan(
                              text:
                                  'Características do equipamento. Como a maioria dos aplicativos, para poder funcionar o bocaboca coleta automaticamente dados sobre as características do seu aparelho, dentre as quais o seu sistema operacional, a versão deste, informações de hardware, o idioma, sinal de internet e bateria.\n'),
                          TextSpan(
                              text:
                                  'Comunicações com o bocaboca. Quando você se comunica com o bocaboca, coletamos informações sobre sua comunicação, incluindo metadados como data, IP e hora das comunicações e todo o seu conteúdo, assim como qualquer informações que você escolha fornecer.\n\n'),
                          TextSpan(
                              text: '1.2. Informações de outras fontes.\n\n'),
                          TextSpan(text: 'Isso pode incluir:\n'),
                          TextSpan(
                              text:
                                  'Informações provenientes de outros usuários. Outros usuários do bocaboca podem produzir informações sobre você, como referências, avaliações de peso e medidas do corpo, mensagens e comentários.\n'),
                          TextSpan(
                              text:
                                  'Dados coletados de outras plataformas. O bocaboca poderá interagir com outras plataformas e outros serviços, como redes sociais, meios de pagamentos e antifraude. Alguns desses serviços podem nos fornecer informações sobre o Usuário, aos quais coletaremos para lhe proporcionar uma melhor experiência e melhorar cada vez mais os nossos serviços, ainda oferecer novas funcionalidades, bem como login de acesso à plataforma e confirmação de pagamentos.\n\n'),
                          TextSpan(text: '2. COMO USAMOS SUAS INFORMAÇÕES.\n'),
                          TextSpan(
                              text:
                                  'Não custa lembrar, prezamos muito pela sua privacidade. Por isso, todos os dados e informações sobre você são tratadas como confidenciais, e somente as usaremos para os fins aqui descritos e autorizados por você, principalmente para que você possa utilizar o bocaboca de forma plena, segura e visando sempre melhorar a sua experiência como Usuário.\n\n'),
                          TextSpan(text: '2.1. Usos autorizados.\n'),
                          TextSpan(
                              text:
                                  'Desta forma, poderemos utilizar seus dados para:\n'),
                          TextSpan(
                              text:
                                  'Permitir que você acesse e utilize todas as funcionalidades do bocaboca;\n'),
                          TextSpan(
                              text:
                                  'Enviar ao Usuário mensagens a respeito de suporte ou serviço solicitado, como alertas, notificações e atualizações;\n'),
                          TextSpan(
                              text:
                                  'Nos comunicar com o Usuário sobre produtos, serviços, promoções, notícias, atualizações, eventos e outros assuntos que o Usuário possa ter interesse;\n'),
                          TextSpan(
                              text:
                                  'Analisar o tráfego dos Usuários em nossos aplicativos.\n'),
                          TextSpan(
                              text:
                                  'Realizar publicidade direcionada conforme seus gostos, interesses e outras informações coletadas;\n'),
                          TextSpan(
                              text:
                                  'Personalizar o serviço para este adequar cada vez mais aos gostos e interesses do Usuário;\n'),
                          TextSpan(
                              text:
                                  'Criarmos novos serviços, produtos e funcionalidades;\n'),
                          TextSpan(
                              text:
                                  'Detecção e prevenção de fraudes, spam e incidentes de segurança;\n'),
                          TextSpan(
                              text:
                                  'Verificar ou autenticar as informações fornecidas pelo Usuário, inclusive comparando a dados coletados de outras fontes;\n'),
                          TextSpan(
                              text:
                                  'Entender melhor o comportamento do Usuário e construir perfis comportamentais;\n'),
                          TextSpan(
                              text:
                                  'Para qualquer fim que você autorizar no momento da coleta de informações;\n'),
                          TextSpan(text: 'Cumprir obrigações legais.\n'),
                          TextSpan(
                              text:
                                  'Eventualmente, poderemos utilizar dados para finalidades não previstas nesta política de privacidade, mas estas estarão dentro das suas legítimas expectativas. O eventual uso dos seus dados para finalidades que não cumpram com essa prerrogativa serão feito mediante sua autorização prévia.\n\n'),
                          TextSpan(text: '2.2. Exclusão dos dados.\n'),
                          TextSpan(
                              text:
                                  'Todos os dados coletados serão excluídos de nossos servidores quando o Usuário assim requisitar, por procedimento gratuito e facilitado, ou quando estes não forem mais necessários ou relevantes para lhe oferecermos os nossos serviços, salvo se houver qualquer razão para a sua manutenção, como eventual obrigação legal de retenção de dados ou necessidade de preservação destes para resguardo de direitos do bocaboca.\n\n'),
                          TextSpan(text: '2.3. Monitoramento.\n'),
                          TextSpan(
                              text:
                                  'O bocaboca se reserva no direito de monitorar toda a plataforma, principalmente para assegurar que as regras descritas em nossos Termos de Uso estão sendo observadas, ou ainda se não há violação ou abuso das leis aplicáveis.\n\n'),
                          TextSpan(text: '2.4. Exclusão de usuário.\n'),
                          TextSpan(
                              text:
                                  'O bocaboca se reserva no direito de excluir determinado Usuário, independente do tipo que for, caso a presente Política ou os Termos de Uso não sejam respeitados. Como prezamos pelo bom relacionamento com os Usuários, reconhecemos que têm o direito de buscar entender os motivos e até contestá-los, o que pode ser feito pelo seguinte e-mail: nutrinho@bocaboca.com.\n\n'),
                          TextSpan(
                              text: '3. COMPARTILHAMENTO DAS INFORMAÇÕES.\n'),
                          TextSpan(
                              text:
                                  'O bocaboca se reserva o direito de fornecer seus dados e informações sobre os Usuários, incluindo interações suas, caso seja requisitado judicialmente para tanto, ato necessário para que a empresa esteja em conformidade com as leis nacionais e internacionais, ou caso o Usuário autorize expressamente. Do contrário, não é de interesse do bocaboca, compartilhar informações dos Usuários.\n\n'),
                          TextSpan(text: '.\n'),
                          TextSpan(text: '4. SEGURANÇA DAS INFORMAÇÕES.\n'),
                          TextSpan(
                              text:
                                  'Todos os seus dados são confidenciais e somente as pessoas com as devidas autorizações terão acesso a eles. Qualquer uso destes estará de acordo com a presente Política. O bocaboca empreenderá todos os esforços razoáveis de mercado para garantir a segurança dos nossos sistemas e dos seus dados. Nosso servidores estão localizados em diferentes locais para garantir estabilidade e segurança, e somente podem ser acessados por meio de canais de comunicação previamente autorizados.\n'),
                          TextSpan(
                              text:
                                  'Todas as suas informações serão, sempre que possível, criptografadas, caso não inviabilizem o seu uso pela plataforma. A qualquer momento você poderá requisitar cópia dos seus dados armazenados em nossos sistemas. Manteremos os dados e informações somente até quando estas forem necessárias ou relevantes para as finalidades descritas nesta Política, ou em caso de períodos pré-determinados por lei, ou até quando estas forem necessárias para a manutenção de interesses legítimos do bocaboca.\n'),
                          TextSpan(
                              text:
                                  'A equipe bocaboca considera a sua privacidade algo extremamente importante e fará tudo que estiver ao alcance para protegê-la. Todavia, não temos como garantir complemente que todos os dados e informações sobre você em nossa plataforma estarão livres de acessos não autorizados, principalmente caso haja compartilhamento indevido das credenciais necessárias para acessar o nosso aplicativo. Portanto, você é o único responsável por manter sua senha de acesso em local seguro e é vedado o compartilhamento desta com terceiros. O Usuário se compromete a notificar o bocaboca imediamente, através de meio seguro, a respeito de qualquer uso não autorizado de sua conta, bem como o acesso não autorizado por terceiros a esta, alterando imediatamente as senhas enquanto analisamos a questão.\n\n'),
                          TextSpan(
                              text:
                                  '5. ATUALIZAÇÕES DA POLÍTICA DE PRIVACIDADE.\n'),
                          TextSpan(
                              text:
                                  'O bocaboca se reserva no direito de alterar esta Política quantas vezes forem necessárias, visando fornecer aos Usuários mais segurança, conveniência, e melhorar cada vez mais a sua experiência. É por isso que é muito importante acessar nossa Política periodicamente. Para facilitar, indicamos no início do documento a data da última atualização. Caso sejam feitas alterações relevantes que ensejem novas autorizações do Usuário, publicaremos uma nova Política de Privacidade, sujeita novamente ao seu consentimento.\n\n'),
                          TextSpan(text: '6. LEI APLICÁVEL.\n'),
                          TextSpan(
                              text:
                                  'Este documento é regido e deve ser interpretado de acordo com as leis da República Federativa do Brasil. Fica eleito o Foro da Comarca de São Paulo, São Paulo, como o competente para dirimir quaisquer questões porventura oriundas do presente documento, com a empressa renúncia a qualquer outro, por mais privilegiado que seja.\n'),
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
