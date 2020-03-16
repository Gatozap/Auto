import 'package:autooh/Objetos/Bonus.dart';
import 'package:autooh/Objetos/Equipamento.dart';
import 'package:autooh/Objetos/Personagem.dart';

Personagem p;
List<Equipamento> ListaEquipamentos = [
  Equipamento(
    nome: 'Corda',
    descricao: 'Corda usada para escalar',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    slot: 'Aparatos',
    isEquipavel: true,
  ),
  Equipamento(
      nome: 'Lanterna portátil',
      descricao: 'Possui iluminação fraca',
      requerimentos: 'duas pilhas AAA',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Lanterna normal',
      descricao: 'Ilumina até 10 metros a sua frente',
      requerimentos: '4 pilhas palito',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Mala de Viagem de Alumínio',
      descricao:
          'uma caixa metálica reforçada, com suportes de espuma. Travas impedem que abra acidentalmente.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Maleta Executiva',
      descricao:
          'pode carregar até 2,5kg de equipamento. A maleta pode ser trancada, mas a fechadura é simples e com pouca segurança',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Sacola Comum',
      descricao:
          ' normalmente são feitas de tecido, mas podem ser de outros materiais. Uma sacola padrão aguenta 8kg de equipamento, enquanto uma grande comporta até 24kg.',
      requerimentos: '4 pilhas palito',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
    nome: 'Mochila',
    descricao:
        ' é feita de material resistente e à prova d’água. Tem uma ou duas partes centrais, assim como vários bolsos exteriores e tiras para prender tendas, sacos de dormir e outros tipos de equipamento.\nPode carregar até 30kg. Uma mochila fornece ao personagem um bônus de equipamento de +1 na Força para determinar a capacidade de carga.',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    slot: 'Aparatos',
    isEquipavel: true,
  ),
  Equipamento(
      nome: 'Câmera Fotográfica 35mm',
      descricao:
          ' a melhor escolha para o fotógrafo profissional, esta câmera pode trocar de lentes e tirar fotos de alta qualidade. Uma câmera é necessária para usar a perícia Ofícios (Artes Plásticas) no aspecto foto gráfico. O filme usado pela câmera precisa ser revelado.',
      requerimentos: 'Filmes',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Câmera Fotográfica Digital',
      descricao:
          'uma câmera digital não usa filme; as fotos são transferidas para um computador como arquivos de imagem. Não é necessária revelação do filme',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Câmera Fotográfica Descartável',
      descricao:
          ' esta é uma câmera de 35mm com filme embutido, que pode pode ser comprada em máquinas de venda automática, loja de souvenirs e lugares semelhantes.\nUma vez que o filme é utilizado, a câmera inteira é entregue para a revelação',
      requerimentos: 'Filmes',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Filmes',
      descricao:
          ' a película onde as fotografias são guardadas, o filme pode ser encontrado em uma variedade de tamanhos e velocidades.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Telefone Celular',
      descricao: 'Aparelho de comunicação digital',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'NootBook',
      descricao: 'Pequenos, leves e portáteis',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Câmera de Vídeo Portátil',
      descricao:
          'Estas câmeras usam fitas de videotape para gravar imagens. A fita pode ser assistida em um aparelho de vídeo cassete, ou através do monitor da própria câmera.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Walkie-Talkie Básico',
      descricao:
          'Esta versão só possui alguns canais. Qualquer um usando um walkie-talkie dentro do alcance pode ouvir a conversa do personagem. Tem um alcance de 3km',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Walkie-Talkie Profissonal',
      descricao:
          'é o modelo mais avançado permitido para civis. Permite programação em vinte freqüências diferentes dentre milhares de opções.\nO que torna possível usar uma freqüência que mais ninguém esteja usando dentro do alcance. O aparelho pode ser usado com ou sem fones de ouvido (já incluídos) e possui um alcance de 22,5 km.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Caixa Preta',
      descricao:
          ' emite tons digitais que enganam o sistema telefônico, permitindo que se faça chamadas e conexões a longa distância sem a necessidade de pagar por elas.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Interceptador de Celular',
      descricao:
          'Quase do tamanho de uma pasta pequena, um interceptador de celular pode detectar e monitorar uma chamada telefônica em uma área de 7,5km ao se conectar aos próprios transmissores do serviço de telefonia móvel',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
    nome: 'Óculos de Visão Noturna',
    descricao:
        'Este tipo de óculos usa absorção de luz passiva para melhorar a visão em condições próximas do escuro total. Eles oferecem a habilidade de ver no escuro (também chamada de Visão no Escuro), mas devido ao campo de visão restrito e perda de percepção de profundidade, estes óculos impõem uma penalidade de –4 em testes de Observar e Procurar.',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    slot: 'Aparatos',
    isEquipavel: true,
  ),
  Equipamento(
      nome: 'Detector de Grampos',
      descricao:
          'Quando ligado na linha telefônica, entre o aparelho e a ligação externa, ajuda a detectar se a linha está grampeada. ',
      requerimentos: 'Usar Computador',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Grampo Telefônico',
      descricao:
          'Estes aparelhos permitem ouvir a conversas em uma linha telefônica',
      requerimentos: 'Pericia Reparos e Usar Computador',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Rastreador de Ligação',
      descricao:
          'Sendo essencialmente um computador especializado, um rastreador de ligação conectado a uma linha telefônica pode rastrear chamadas feitas para aquela linha, mesmo quando o telefone que fez a chamada possui uma máscara para identificador de chamada. A única limitação é o tempo para localizar a chamada.',
      requerimentos: 'Usar Computador CD 10',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Cortador de Trava',
      descricao:
          'Semelhante a um alicate muito grande, só que mais forte e pesado, este item pode cortar cadeados ou correntes.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Estrepes',
      descricao:
          'Estrepes são pequenos espetos de ferro com quatro pontas, feitos de forma que uma delas sempre fique para cima quando o item está em repouso sobre uma superfície',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit para Abrir Carros',
      descricao:
          'Este kit é constituído de barras de metal de formatos estranhos, que podem ser enfiadas através das janelas do carro para abrir fechaduras.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit de Química',
      descricao:
          'Um laboratório portátil para usar a perícia Ofícios (Química). Inclui ferramentas e componentes necessários para misturar e analisar ácidos, bases, explosivos, gases tóxicos e outros compostos químicos.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit de Demolição',
      descricao:
          'Contém tudo necessário para usar a perícia Demolição e programar detonadores, conectar aparelhos explosivos e desarmá-los. Detonadores devem ser comprados separadamente.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit de Disfarce',
      descricao:
          'Contém tudo necessário para usar a perícia Disfarces, incluindo maquiagem, pincéis, espelhos, perucas e outros acessórios. Porém, não contém roupas e uniformes.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Fita Adesiva',
      descricao:
          'A utilidade da fita adesiva só é limitada pela imaginação do personagem. O tipo de fita adesiva na tabela é resistente, com 5cm de largura (um rolo tem 20m de fita), agüenta até 100kg por um longo tempo ou 150kg por 1d6 rodadas.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit de Eletrônica Básico',
      descricao:
          'Esta coleção de ferramentas manuais e pequenas peças normalmente inclui uma variedade de alicates, chaves de fenda, pinças, soldas e fios.\nEste kit pequeno permite fazer testes de Reparos em aparelhos elétricos e eletrônicos sem penalidades.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
      nome: 'Kit de Eletrônica Luxuoso',
      descricao:
          'Este kit possui várias ferramentas especializadas de diagnóstico e reparos, assim como inúmeras peças extras.\nFornece um bônus de equipamento de +2 em testes de Reparos em aparelhos elétricos e eletrônicos, e permite fazer testes de Ofícios (Eletrônica) sem penalidade.',
      updated_at: DateTime.now(),
      created_at: DateTime.now(),
      slot: 'Aparatos'),
  Equipamento(
    nome: 'Binóculos',
    descricao: 'Aumenta seu alcance no Observar',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    slot: 'Aparatos',
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Capacete de moto',
    descricao: 'Protege de impactos',
    slot: 'Cabeça',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Elmo de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Cabeça',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Ombreira de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Ombros',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Espada de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Arma',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Escudo de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Escudo',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Arco de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Arco',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Flechas de batalha',
    descricao: 'Perfura armaduras de placa',
    slot: 'Munição',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Peitoral de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Peitoral',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Bracelete de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Bracelete',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Calça de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Calça',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Luvas de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Luvas',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Botas de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Botas',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Capa de batalha',
    descricao: 'Protege de armas cortantes',
    slot: 'Capa',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Anel de Fogo',
    descricao: 'Aumenta sua vontade como o fogo ardente de sua alma',
    slot: 'Anel',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Anel de Vento',
    descricao: 'Seus Reflexos são como o vento',
    slot: 'Anel',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
  Equipamento(
    nome: 'Colar de Vento',
    descricao: 'Seus Reflexos são como o vento',
    slot: 'Colar',
    updated_at: DateTime.now(),
    created_at: DateTime.now(),
    isEquipavel: true,
  ),
];
