import 'package:autooh/Objetos/Bonus.dart';
import 'package:autooh/Objetos/Talento.dart';

List<Talento> ListaTalentos = [
  Talento(
      nome: 'Acrobático',
      descricao:
          'Você é mais ágil que o normal. \n Benefícios: você recebe um bônus de +2 em todos os testes de Saltar e Acrobacia. \n Especial: a perícia Acrobacia não pode ser usada sem treinamento.',
      bonus: [
        Bonus(
            atributo: 'Saltar',
            bonus: 2,
            isPericia: true,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Acrobacia',
            bonus: 2,
            isPericia: true,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
    nome: 'Acuidade com Arma:',
    descricao:
        'Escolha uma arma de combate corpo-a-corpo leve, um sabre (se o personagem puder usá-lo com uma mão) ou uma corrente.\n Você é especialmente ágil com essa arma, recebendo mais benefícios por sua Destreza em vez da Força para usá-la. \n com a arma escolhida, você pode usar seu modificador \n de Destreza ao invés de seu modificador de Força nas jogadas de ataque.',
    requerimentos: 'Proficiente com a arma, BBA+1',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
  ),
  Talento(
      nome: 'Afinidade com Animais',
      descricao:
          'Você se dá bem com animais. \n Benefício: você recebe um bônus de +2 em todos os testes de Adestrar Animais e Cavalgar. \n Especial: a perícia Adestrar Animais não pode ser usada sem treinamento.',
      bonus: [
        Bonus(
            atributo: 'Adestrar Animais',
            bonus: 2,
            isPericia: true,
            isActive: true),
        Bonus(
            atributo: 'Cavalgar',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Alvo Elusivo',
      descricao:
          'Quando em combate corpo-a-corpo, você consegue usar seus oponentes como cobertura. \n Benefício: quando estiver enfrentando um oponente ou vários  em combate corpo-a-corpo, outros oponentes \n tentando acertar o personagem com ataques de longa distância sofrem uma penalidade de –4 \n Especial: um oponente com o talento Precisão tem sua penalidade reduzida em –4 para acertar o alvo.',
      requerimentos: 'Destreza 13, Artes Marciais Defensivas.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Arremesso em Combate',
      descricao:
          'Você tem a capacidade de usar o peso de seu oponente contra ele. \n Benefício: você recebe um bônus de +2 em testes resistidos de \n Força e Destreza toda vez que tentar Imobilizar ou Agarrar, ou quando \n tentar evitar uma tentativa de Imobilizar ou Agarrar feita contra você.',
      requerimentos: 'Artes Marciais Defensivas.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Acrobático',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Arremesso em Combate Aprimorado',
      descricao:
          'Você é extremamente competente em usar o peso de seu oponente contra ele. \n Benefício: em combate corpo-a-corpo, se o oponente erra o personagem, este último \n pode tentar Imobilizá-lo. Esta ação conta como um ataque de oportunidade. \n Especial: este talento não garante ao personagem mais ataques de oportunidade do que lhe é permitido normalmente em uma rodada.',
      requerimentos:
          'Artes Marciais Defensivas, Arremesso em Combate, Bônus Base de Ataque +3.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Artes Marciais',
      descricao:
          'Você é treinado na arte do combate desarmado e capaz de causar mais dano com seus golpes. \n Benefício: com um ataque desarmado, você causa dano letal ou não-letal (à sua escolha) igual a 1d4 + seu modificador de Força. \n O ataque desarmado conta como ataque armado, o que significa que os oponentes não ganham ataques de oportunidade quando você os ataca desarmado. \n Mas você ainda pode fazer ataques de oportunidade contra oponentes que provoquem esse tipo de ataque. ',
      requerimentos: 'Bônus Base de Ataque +1.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Artes Marciais Aprimoradas',
      descricao:
          'Você é altamente treinado na arte do combate desarmado e capaz de causar mais dano com seus golpes. \n Benefício: a margem de ameaça de seus golpes desarmados aumenta para 19-20.',
      requerimentos: 'Artes Marciais, Bônus Base de Ataque +4.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Artes Marciais Avançadas',
      descricao:
          'Você é um grande mestre na arte do combate desarmado e capaz de causar danos sérios com seus golpes. \n Benefícios: quando você consegue um acerto decisivo em um ataque desarmado, causa o triplo de dano.',
      requerimentos:
          'Artes Marciais, Artes Marciais Aprimoradas, Bônus Base de Ataque +8.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Artes Marciais Defensivas',
      descricao:
          'Você tem o talento necessário para evitar ser atingido em combates corpo-a-corpo. \n Benefício: você recebe um bônus de esquiva de +1 na Defesa contra ataques corpo-a-corpo. \n Especial: uma condição que faz o personagem perder seu bônus de Destreza na Defesa também faz com que ele perca seus bônus de esquiva. Bônus de esquiva se acumulam uns com os outros, ao contrário da maioria dos outros tipos de bônus.',
      requerimentos: '',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Ataque em Veículo',
      descricao:
          'Você é capaz de atacar de dentro de um veículo em movimento com facilidade. \n Benefício: você não sofre penalidade por velocidade quando estiver fazendo um ataque de um veículo em movimento. Além disso, se o personagem for o motorista, pode usar sua ação de ataque em qualquer ponto do movimento do veículo.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Ataque Giratório',
      descricao:
          'Você é capaz de atacar todos os oponentes à sua volta em combate corpo-a-corpo. \n Benefício: quando usa uma ação de ataque total, você pode desistir de seus ataques normais e fazer, ao invés disso, um ataque com seu melhor bônus base contra cada oponente adjacente.',
      requerimentos:
          'Destreza 13, Inteligência 13, Esquiva, Mobilidade, Deslocamento, Especialista em Combate, Bônus Base de Ataque +4.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Ataque Poderoso',
      descricao:
          'Você é capaz de desferir ataques de poder extraordinário quando em combate corpo-a-corpo.\n Benefício: durante sua ação, antes de fazer as jogadas de ataque, o personagem pode subtrair um valor de todas as jogadas de ataque e somá-lo a todas as jogadas de dano. Esse número não pode exceder seu Bônus Base de Ataque. As alterações no ataque e no dano são aplicadas até sua próxima ação.',
      requerimentos: 'Força 13.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Atento',
      descricao:
          'Você é um observador nato.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Investigar e Sentir Motivação.\n Especial: a perícia Investigar não pode ser usada sem treinamento.',
      bonus: [
        Bonus(
            atributo: 'Investigar',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Sentir Motivação',
            bonus: 2,
            isPericia: true,
            isActive: true)
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Acrobático',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Atlético',
      descricao:
          'Você tem aptidão natural para atividades físicas.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Escalar e Natação.',
      bonus: [
        Bonus(
            atributo: 'Escalar',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Natação',
            bonus: 2,
            isPericia: true,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Acrobático',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Briga',
      descricao:
          'Você é bom de briga.\n Benefício: ao atacar desarmado, o personagem recebe um bônus de competência de +1 na jogadas de ataque e causa 1d6 + seu modificador de Força de dano não letal.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Briga Aprimorada',
      descricao:
          'Você é muito bom de briga.\n Benefício: ao atacar desarmado, o personagem recebe um bônus de competência de +2 na jogada de ataque e causa 1d8 + seu modificador de Força de dano não letal.',
      requerimentos: 'Briga, Bônus Base de Ataque +3.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Briga de Rua',
      descricao:
          'Você é perito nas táticas de luta de rua.\n Benefício: uma vez por rodada, se o personagem for bem-sucedido em um ataque corpo-a-corpo, ataque desarmado ou com arma leve, causa 1d4 pontos de dano extra.',
      requerimentos: 'Briga, Base bônus de Ataque +2.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Cauteloso',
      descricao:
          'Você é extremamente cuidadoso com tarefas delicadas.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Demolição e Operar Mecanismo.\n Especial: as perícias Demolição e Operar Mecanismo não podem ser usadas sem treinamento.',
      bonus: [
        Bonus(
            atributo: 'Demolição',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Operar Mecanismo',
            bonus: 2,
            isPericia: true,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Cirurgia',
      descricao:
          'Você é capaz de executar procedimentos cirúrgicos no intuito de curar ferimentos.\n Benefício: o personagem pode usar a perícia Tratar Ferimentos para realizar uma cirurgia sem penalidade.',
      requerimentos: '4 graduações em Tratar Ferimentos.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Combater com Duas Armas',
      descricao:
          'Seu treinamento permite que você use uma arma em cada mão.\n Benefício: as penalidades para combater com duas armas são reduzidas em 2. As armas usadas precisam ser ambas de combate corpo-a-corpo ou de combate à distância (o personagem não pode escolher armas de tipos diferentes em cada mão). ',
      requerimentos: ' Destreza 13',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Combater Com Duas Armas Aprimorado',
      descricao:
          'Você e um especialista na arte de combater com uma arma em cada mão.\n Benefício: o personagem recebe um segundo ataque com sua mão esquerda, mas com –5 de penalidade neste ataque. Este talento também permite ao personagem utilizar uma arma de combate corpo-a-corpo em uma mão e uma de ataque à distância na outra.',
      requerimentos:
          'Destreza 13, Combater Com Duas Armas, Bônus Base de Ataque +6.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Combater com Duas Armas Avançado',
      descricao:
          'Você é um mestre na arte de combater com uma arma em cada mão.\n Benefício: o personagem recebe um terceiro ataque com a arma em sua mão inábil, embora sofra uma penalidade de –10 neste ataque. Este talento permite que o personagem use uma arma de corpo-a-corpo em uma mão e uma arma à distância na outra.',
      requerimentos:
          'Destreza 13, Combater com Duas Armas, Combater com Duas Armas Aprimorado, Bônus Base de Ataque +11.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Conduzir',
      descricao:
          'Veículo de Superfície.\n Selecione uma classe de veículo de superfície (veículo pesado, barcos a motor, barcos à vela, navios, veículos de esteira). O personagem é proficiente em pilotar a classe de veículo de superfície escolhida.\n Benefício: o personagem não sofre penalidade em testes de Condução ou jogadas de ataque quando estiver conduzindo um veículo da classe selecionada.\n Especial: o personagem pode adquirir este talento múltiplas vezes, e escolhe uma nova classe de veículo cada vez que adquirir o talento.',
      requerimentos: '4 graduações em Condução.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Confiante',
      descricao:
          'Você tem extrema confiança em suas habilidades.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Jogos e Intimidar, e em testes de nível para resistir a Intimidar.',
      bonus: [
        Bonus(
            atributo: 'Jogos',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Intimidar',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Confiável',
      descricao:
          'Você parece amigável.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Diplomacia e Obter Informação.',
      bonus: [
        Bonus(
            atributo: 'Diplomacia',
            bonus: 2,
            isPericia: true,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now()),
        Bonus(
            atributo: 'Obter Informação',
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Construtor',
      descricao:
          'Você tem uma aptidão natural para construir coisas.\n Benefício: escolha duas das seguintes perícias: Ofícios (eletrônica), Ofícios (estruturas), Ofícios (mecânica) e Ofícios (química). O personagem recebe um bônus de +2 nos testes com as perícias escolhidas.\n Especial: o personagem pode selecionar este talento duas vezes. Na segunda vez, o personagem aplica o talento às duas perícias que ele não pegou anteriormente. As perícias Ofício (química), Ofício (eletrônica) e Ofício (mecânica) não podem ser usadas sem treinamento.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Corrida',
      descricao:
          'Você corre Rápido.\n Benefício: quando estiver correndo, o personagem se move cinco vezes seu deslocamento básico em vez de quatro vezes. Se o personagem estiver usando uma armadura pesada, poderá se mover quatro vezes mais rápido ao invés de três. Se o personagem der um salto com corrida, recebe um bônus de competência de +2 em seu teste de Saltar.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Criativo',
      descricao:
          'Você é criativo por natureza.\n Benefício: escolha uma das seguintes perícias: Atuação (artes cênicas), Atuação (canto),\n Atuação (comediante), Atuação (dança), Atuação (instrumentos de corda), Atuação (instrumentos de percussão), \n Atuação (instrumentos de sopro), Atuação (teclado), Ofícios (artes plásticas) ou Ofícios (escrita).\n O personagem recebe um bônus de +2 em todos os testes com as duas perícias escolhidas.\n Especial: um personagem pode selecionar este talento até cinco vezes. Em cada vez, escolhe mais duas perícias da lista fornecida.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Culto',
      descricao:
          'Você tem uma educação formal em algumas áreas específicas de conhecimento.\n Benefício: escolha quaisquer duas perícias de Conhecimento. O personagem recebe um bônus de +2 em todas as jogadas que envolvam estas perícias.\n Especial: o personagem pode escolher esta perícia até sete vezes. Em cada uma das vezes, escolhe mais duas novas perícias de Conhecimento.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Desarme Aprimorado',
      descricao:
          'Você é capaz de desarmar mais facilmente seus adversários em combate corpo-a-corpo.\n Benefício: seu personagem não provoca um ataque de oportunidade quando tenta fazer a manobrar Desarmar contra um oponente, e nem esse oponente tem a chance de desarmar o personagem em retorno.',
      requerimentos: 'Inteligência 13, Especialização em Combate.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Desequilibrar Oponente',
      descricao:
          'Você é capaz de manter seus oponentes desequilibrados durante combate corpo-a-corpo.\n Benefício: durante a ação do personagem, ele pode escolher um oponente uma categoria maior ou menor que ele.\n Este oponente não recebe seu modificador de Força nas jogadas de ataque ao tentar atacar o personagem (se o oponente tem uma penalidade na Força, ele ainda sofre seus efeitos).',
      requerimentos: 'Artes Marciais Defensivas, Bônus Base de Ataque +6.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Deslocamento',
      descricao:
          'Você faz ataques rápidos e se movimenta com agilidade.\n Benefício: quando estiver atacando com uma arma de corpo-acorpo, o personagem pode se mover antes e depois do ataque, desde que a distância total não seja maior que seu deslocamento.\n Mover-se deste modo não provoca ataques de oportunidade por parte do alvo (embora possa provocar ataques de oportunidade por parte de outros oponentes normalmente).\n O personagem não pode usar este talento se estiver carregando algo pesado ou usando uma armadura pesada.',
      requerimentos:
          'Destreza 13, Esquiva, Mobilidade, Base bônus de Ataque +4.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Discreto',
      descricao:
          'Por algum motivo, você é menos conhecido que os outros da sua classe e nível, ou prefere não chamar muito a atenção.\n Benefício: reduz a Reputação do personagem em 3 pontos. ',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Dissimulado',
      descricao:
          'Você tem o talento natural de ludibriar as pessoas e causar falsas impressões quando quer.\nBenefício: o personagem recebe +2 de bônus nos testes de Blefar e Disfarces. ',
      bonus: [
        Bonus(atributo: 'Blefar', bonus: 2, isPericia: true, isActive: true),
        Bonus(atributo: 'Disfarces', bonus: 2, isActive: true, isPericia: true)
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Encontrão Aprimorado',
      descricao:
          'Você sabe como empurrar ou afastar seus oponentes.\n Benefício: quando o personagem usa a manobra Encontrão, não provoca um ataque de oportunidade do defensor.',
      requerimentos: 'Força 13, Ataque Poderoso.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialista em Medicina',
      descricao:
          'Você tem aptidão para medicina.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Ofícios (farmacêutica) e testes de Tratar Ferimentos.\n Especial: a perícia Ofícios (farmacêutica) não pode ser usada sem treinamento.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialista em Veículos',
      descricao:
          'Você tem aptidão para operar veículos.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Pilotar e Condução.',
      bonus: [
        Bonus(atributo: 'Pilotar', bonus: 2, isPericia: true, isActive: true),
        Bonus(atributo: 'Condução', bonus: 2, isPericia: true, isActive: true)
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialização em Combate',
      descricao:
          'Você é capaz de usar suas habilidades de combate tanto para atacar quanto para se defender.\n Benefício: quando o personagem faz um ataque ou um ataque total em combate corpo-a-corpo, ele pode colocar uma penalidade de até –5 em sua jogada de ataque e adicionar esse mesmo número (até +5) à sua Defesa.\n Esse número não pode exceder o Bônus Base de Ataque do personagem. A mudança na jogada de ataque e na Defesa dura até a próxima ação do personagem. A mudança na jogada de ataque e na Defesa conta como um bônus de esquiva\n (e sendo assim, acumula-se com outros bônus de esquiva que o personagem possa ter).',
      requerimentos: 'Inteligência 13',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialização em Perícia',
      descricao:
          'Você tem certo dom para uma determinada perícia.\n Benefícios: o personagem designa uma perícia que possua. Em todos os testes dessa perícia recebe um bônus de +3.\n Especial: este talento não permite usar uma perícia que não pode ser testada sem treinamento.\n Na prática, o talento tem como pré-requisito possuir pelo menos uma graduação na perícia escolhida. Um personagem pode escolher este talento várias vezes, cada vez para uma perícia diferente.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialização Aprimorada em Perícia',
      descricao:
          'Você consegue ser melhor que o normal com determinada perícia.\n Benefícios: o personagem designa uma perícia que já tenha escolhido para ser afetada pelo talento Especialização em Perícia. O bônus que recebe será +4 ao invés de +3.\n Especial: um personagem pode escolher este talento várias vezes, cada uma para uma perícia diferente, desde que preencha os prérequisitos.',
      requerimentos:
          'Especialização em Perícia, personagem de 5º nível ou maior.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Ricochetear',
      descricao:
          'Você é capaz de fazer com que uma bala ricocheteie para acertar alguém que esteja sob cobertura.\n Benefício: o personagem pode usar uma superfície sólida e relativamente lisa para ricochetear uma bala (como uma porta, parede ou piso de concreto ou metal) e acertar um alvo a até 3m dessa superfície.\n O personagem pode ignorar a cobertura entre ele e o alvo. Entretanto, opersonagem sofre uma penalidade de –2 em sua jogada de ataque e o dano é reduzido em –1 dado.\n Especial: a superfície não precisa ser perfeitamente lisa e regular;um muro de tijolos ou uma rua asfaltada podem ser usados. O alvo não pode ter cobertura de nove décimos ou mais para que o personagem tente ricochetear o tiro.',
      requerimentos: 'Tiro Certeiro, Precisão.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Saque Rápido',
      descricao:
          'Você consegue sacar sua arma mais rápido que o normal.\n Benefício: o personagem pode sacar sua arma como uma ação livre.',
      requerimentos: 'Bônus Base de Ataque +1.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Separar',
      descricao:
          'Em um ataque de combate corpo-a-corpo, você é capaz de acertar a arma de um oponente ou outro objeto que ele esteja carregando.\n Benefício: o ataque do personagem a um objeto que está sendo seguro ou carregado por um oponente (como uma arma, por exemplo) não provoca um ataque de oportunidade. \n O personagem recebe um bônus de +4 em todas a jogadas deataque para acertar um objeto seguro ou carregado por outra pessoa.\n O personagem causa dano normal dobrado contra objetos em qualquer situação.',
      requerimentos: 'Força 13, Ataque Poderoso.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Surto Heróico',
      descricao:
          'Graças a seu ímpeto de heroísmo, você é capaz de realizar uma ação extra por rodada.\n Benefício: o personagem pode realizar uma ação extra de movimento ou de ataque em uma rodada, seja antes ou depois de sua ação regular. O número de vezes por dia que o personagem pode usar o Surto Heróico depende de seu nível, como mostrado a seguir, mas nunca mais de uma vez por rodada.\n Nível 1-4: 1 vez por dia \n Nível 5-8: 2 vezes por dia \n Nível 9-12: 3 vezes por dia\n Nível 13-16: 4 vezes por dia\n Nível 17-20: 5 vezes por dia',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Tiro Certeiro',
      descricao:
          'Você é capaz de acertar tiros com precisão com armas de ataque à distância em alvos próximos.\n Benefício: o personagem recebe um bônus de +1 nas jogadas de ataque e dano com armas de combate à distância, apenas contra oponentes que estejam a menos de 9m de distância.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Tiro Duplo',
      descricao:
          'Usando uma arma de fogo você é capaz de fazer dois disparos rápidos contra um único alvo.\n Benefício: quando estiver usando uma arma de fogo semi-automática com pelo menos duas balas carregadas, o personagem pode atirar estas duas balas em um único ataque contra um alvo único.\n O personagem sofre uma penalidade de –2 na jogada de ataque, mas causa +1 dado de dano. Usar este talento dispara duas balas, e só pode ser feito se arma estiver carregada com pelo menos duas balas.',
      requerimentos: 'Destreza 13, Tiro Certeiro.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Tiro em Movimento',
      descricao:
          'Seu treinamento permite que você ataque de um veículo em movimento.\n Benefício: quando o personagem estiver atacando com uma arma de ataque à distância, ele pode se mover antes e depois do ataque, desde que a distância total não seja maior que seu deslocamento. Mover-se deste modo não provoca ataques de oportunidade por parte do alvo, embora possa provocar ataques de oportunidade por parte de outros oponentes normalmente.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Tiro Longo',
      descricao:
          'Seus tiros de longa distância vão muito mais longe.\n Benefício: quando um personagem usa uma arma de fogo ou uma arma arcaica de ataque à distância, o incremento de distância da arma é aumentado em 50% (multiplique por 1.5).\n Quando o personagem usa uma arma de arremesso, o incremento de distância é dobrado.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Tolerância',
      descricao:
          'Você é muito mais resistente em tarefas físicas do que as pessoas normais.\n Benefício: o personagem recebe um bônus de +4 nos seguintes testes: de Natação realizados de hora em hora para evitar ficar fatigado; de Constituição para continuar correndo; de Constituição para prendera respiração;\n de Constituição para evitar dano por fome ou sede; de Fortitude para evitar dano por fome ou sede; de Fortitude para evitar dano em ambientes quentes ou frios \n e de Fortitude para resistir a afogamento ou asfixia.\n Além disso, o personagem pode dormir trajando armadura média ou leve sem ficar fatigado.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Trespassar',
      descricao:
          'Após realizar um ataque eficiente, você pode realizar outro ataque em seguida contra outro oponente.\n Benefício: se o personagem causar dano suficiente para derrubar um oponente (em geral reduzindo os Pontos de Vida dele para 0 ou menos, matando-o),\n ganhará um ataque adicional contra outra criatura próxima.\n Não é possível dar um passo de 1,5m antes de fazer esse ataque adicional, e a jogada de ataque é feita com a mesma arma e o mesmo bônus de ataque usado para derrubar a criatura anterior.\n Opersonagem pode usar essa habilidade apenas uma vez por rodada.',
      requerimentos: 'Força 13, Ataque Poderoso.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Trespassar Aprimorado',
      descricao:
          'Após realizar um ataque eficiente, você pode realizar outro ataque em seguida contra outro oponente e assim sucessivamente, sem limites na rodada.\n Benefício: como em Trespassar, exceto que o personagem não tem um número limite de vezes que o talento pode ser usado na rodada. ',
      requerimentos:
          'Força 13, Ataque Poderoso, Trespassar, Bônus Base de Ataque +4.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Arma Arcaica',
      descricao:
          'Escolha uma arma arcaica de corpo-a-corpo. O personagem passa a ser proficiente com esta arma.\n Benefício: você não sofre penalidade nas jogadas de ataque com qualquer tipo de arma arcaica.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Arma de Corpo-a-Corpo Exótica',
      descricao:
          'Escolha uma arma de corpo-a-corpo exótica de corpo-a-corpo. O personagem passa a ser proficiente com esta arma.\n Benefício: você faz uma jogada de ataque com a arma escolhida normalmente.',
      requerimentos: 'Bônus Base de Ataque +1.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Arma de Fogo Avançada',
      descricao:
          'Você foi treinado no uso de armas de fogo pessoal em modo de fogo automático.\n Benefícios: você pode atirar com qualquer arma de fogo pessoal em modo de fogo automático sem penalidade (desde que a arma tenha a opção de fogo automático).',
      requerimentos: 'Usar Arma de Fogo Pessoal.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Arma de Fogo Exótica',
      descricao:
          'Escolha um tipo de arma da seguinte lista: metralhadoras pesadas,lançadores de granadas e lançadores de foguetes. O personagem passa a ser proficiente com esta arma.\n Benefício: o personagem faz jogadas de ataque com a armanormalmente.\n Especial: um personagem pode adquirir este talento até quatrovezes. Cada vezes que adquire o talento, ele seleciona um grupo diferente de armas.',
      requerimentos: 'Usar Arma de Fogo Pessoal, Usar Arma de Fogo Avançado.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Armadura (leve)',
      descricao:
          'Você é proficiente com armaduras leves.\n Benefício: você é proficiente com este tipo de armadura. Quando estiver usando o tipo de armadura apropriado a este talento, você adiciona o bônus de equipamento total da armadura à sua Defesa.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Armadura (média)',
      descricao:
          'Você é proficiente com armaduras médias.\n Benefício:  Usar Armadura (média).',
      requerimentos: 'Usar Armadura (leve).',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Armadura (pesada)',
      descricao:
          'Você é proficiente com armaduras pesadas.\n Benefício:Usar Armadura (pesada).',
      requerimentos: 'Usar Armadura (leve), Usar Armadura (média).',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Armas de Fogo Pessoais',
      descricao:
          'Você é proficiente com todos os tipos de armas de fogo pessoais.\n Benefício: o personagem pode usar qualquer arma de fogo pessoal sem penalidade.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Usar Armas Simples',
      descricao:
          'Você sabe usar qualquer tipo de arma simples.\n Benefício: o personagem pode atacar com esse tipo de arma normalmente',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Vitalidade',
      descricao:
          'Você suporta mais danos que outras pessoas.\n Benefício: o personagem recebe +3 Pontos de Vida.\n Especial: você pode escolher este talento diversas vezes. Seus efeitos se acumulam.',
      bonus: [
        Bonus(
            atributo: 'PV',
            bonus: 3,
            isActive: true,
            isPericia: false,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Vontade de Ferro',
      descricao:
          'Você tem uma imensa força de vontade.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de resistência de Vontade.',
      bonus: [
        Bonus(
            atributo: 'Vontade',
            bonus: 2,
            isPericia: false,
            isActive: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now())
      ],
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Especialização Avancada em Pericia',
      requerimentos:
          'Especialização em Perícia, Especialização Aprimorada em Perícia, personagem de 9º nível ou maior.',
      descricao:
          'Sua naturalidade e facilidade em usar determinada perícia são espantosas.\n Benefícios: o personagem designa uma perícia que já tenha escolhido para ser afetada pelo talento Especialização Aprimorada em Perícia. O bônus que ele recebe será +5 ao invés de +4.\nEspecial: um personagem pode escolher este talento várias vezes, cada uma para uma perícia diferente, desde que preencha os prérequisitos',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Esquiva',
      requerimentos: ' Destreza 13.',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Você é bom em se esquivar de golpes.\n Benefício: durante sua ação, o personagem pode escolher um oponente, recebendo +1 de bônus Defesa contra qualquer ataque feito por esse inimigo. O personagem pode escolher um novo oponente em qualquer ação.\nEspecial: uma condição que faz o personagem perder seu bônus de Destreza na Defesa também faz com que ele perca seus bônus de esquiva. Bônus de esquiva se acumulam uns com os outros, ao contrário da maioria dos outros tipos de bônus.'),
  Talento(
    nome: 'Esquivar Com Veículo',
    descricao:
        'Você é capaz de se esquivar dirigindo um veículo.\nBenefício: quando o personagem está dirigindo um veículo, durante sua ação, ele escolhe um outro veículo ou oponente. O veículo do personagem e todos que estiverem dentro dele recebem um bônus de +1 nos testes de Defesa contra os ataques do veículo ou oponente escolhido.\nO personagem pode escolher um novo veículo ou oponente a cada ação.',
    requerimentos:
        'Destreza 13, 6 graduações em Condução, Especialista em Veículos.',
  ),
  Talento(
      nome: 'Estudioso',
      bonus: [
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            updated_at: DateTime.now(),
            atributo: 'Decifrar Escrita'),
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            updated_at: DateTime.now(),
            atributo: 'Pesquisa')
      ],
      descricao:
          'Você tem gosto por estudos e pesquisas.\nBenefício: o personagem recebe um bônus de +2 em todos os testes de Decifrar Escrita e Pesquisa.'),
  Talento(
    nome: 'Finta Aprimorada',
    descricao:
        'Você sabe como enganar ou desviar a atenção do seu adversário durante combate corpo-a-corpo com mais facilidade que o normal.\nBenefício: o personagem pode fazer um teste de Blefar durante o combate como uma ação de movimento. O personagem recebe +2 de bônus em testes de Blefar feitos para fintar em ataques corpo-a-corpo. \nNormal: Fintar em combate exige uma ação de ataque.',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    requerimentos: 'Pré-Requisito: Inteligência 13, Briga, Briga de Rua.',
  ),
  Talento(
    nome: 'Flexível',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você tem juntas flexíveis e habilidade manual acima do normal. \nBenefícios: o personagem recebe um bônus de +2 em todos os testes de Arte da Fuga e Prestidigitação.\nEspecial: as perícias Arte da Fuga e Prestidigitação não podem ser usadas sem treinamento.',
    bonus: [
      Bonus(
          bonus: 2,
          isActive: true,
          isPericia: true,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          atributo: 'Prestidigitação'),
      Bonus(
          bonus: 2,
          isActive: true,
          isPericia: true,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          atributo: 'Arte da Fuga')
    ],
  ),
  Talento(
    nome: 'Focado',
    bonus: [
      Bonus(
          bonus: 2,
          isActive: true,
          isPericia: true,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          atributo: 'Equilíbrio'),
      Bonus(
          bonus: 2,
          isActive: true,
          isPericia: true,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          atributo: 'Concentração')
    ],
    descricao:
        'Você tem maior capacidade de permanecer concentrado, independente da situação.\nBenefício: o personagem recebe um bônus de +2 em todos os seus testes de Equilíbrio e Concentração.',
  ),
  Talento(
    nome: 'Foco em Arma',
    descricao:
        'Você sabe lutar melhor com certo tipo de arma ou técnica.\n Benefício: o personagem adiciona +1 em todas as suas jogadas de ataque com a arma escolhida. Ataque desarmado e agarrar também podem ser escolhidos como “armas” para receber o benefício deste talento.\nEspecial: o personagem pode escolher este talento diversas vezes. Cada vez que é escolhido, precisa determinar uma arma ou técnica diferente.',
    requerimentos:
        'Pré-Requisitos: Proficiente com a arma, Bônus Base de Ataque +1.',
  ),
  Talento(
      nome: 'Furtivo',
      descricao:
          'Você sabe se manter despercebido.\nBenefício: o personagem recebe +2 de bônus em todos os testes de Esconder-se e Furtividade.',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      bonus: [
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            atributo: 'Furtividade'),
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            atributo: 'Esconder')
      ]),
  Talento(
      nome: 'Grande Fortitude',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Você é fisicamente mais resistente que as pessoas normais.\nBenefício: o personagem recebe um bônus de +2 em todos os testes de resistência de Fortitude.',
      bonus: [
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: false,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            atributo: 'Fortitude'),
      ]),
  Talento(
      nome: 'Guia',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Você sabe se orientar em espaços abertos.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Navegação e Sobrevivência.',
      bonus: [
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            atributo: 'Navegação'),
        Bonus(
            bonus: 2,
            isActive: true,
            isPericia: true,
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            atributo: 'Sobrevivência')
      ]),
  Talento(
    nome: 'Herói de Ação',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você é um herói de ação, e tem mais Pontos de Ação para provar!\nBenefício: você recebe 1 Ponto de Ação extra por nível. Ou seja, recebe um número de Pontos de Ação igual a 6 + metade de seu nível de personagem, arredondado para baixo, no 1º nível e novamente cada vez que avança de nível.\nNormal: todos os personagens recebem um número de Pontos de Ação igual a 5 + metade de seu nível de personagem, arredondado para baixo, no 1º nível e novamente cada vez que avançam de nível. \nEspecial: você pode adquirir este talento múltiplas vezes. Os efeitos se acumulam — ou seja, adquirindo o talento duas vezes você recebe um número de Pontos de Ação igual a 7 + metade de seu nível de personagem, arredondado para baixo, no 1º nível e novamente cada vez que avança de nível.',
  ),
  Talento(
      nome: 'Imobilização Aprimorada',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Você recebeu treinamento para agarrar e atacar em seguida seu oponente em combate corpo-a-corpo.\nBenefício: o personagem não provoca um ataque de oportunidade quando tenta a manobra Imobilizar contra um oponente enquanto estiver desarmado. Se o personagem imobiliza o oponente em combate corpo-acorpo, pode também imediatamente fazer um ataque corpo-a-corpo contra o oponente, como se não tivesse usado sua ação de ataque na tentativa de Imobilizar.',
      requerimentos:
          'Pré-Requisitos: Inteligência 13, Especialização em Combate.'),
  Talento(
      nome: 'Iniciativa Aprimorada',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Você reage mais rápido que o normal em situações de combate.\n Benefício: o personagem recebe um bônus de circunstância de +4 em seus testes de Iniciativa.',
      bonus: [
        Bonus(
          bonus: 4,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          isActive: true,
          isPericia: false,
          atributo: 'Iniciativa',
        )
      ]),
  Talento(
    nome: 'Limite de Dano Massivo Aprimorado',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você é capaz de suportar grande quantidade de dano de uma única vez.\nBenefício: o personagem aumenta seu limite de dano massivo em 3 pontos. \nNormal: um personagem sem este talento tem um limite de dano massivo igual à sua Constituição atual. Com este talento, o limite de dano massivo passa a ser igual à Constituição atual +3. \nEspecial: o personagem pode adquirir este talento múltiplas vezes. Os efeitos se acumulam. Lutar às Cegas Você é capaz de lutar corpo-a-corpo mesmo que seus inimigos não possam ser vistos ou estejam camuflados. Benefício: em um combate corpo a corpo, sempre que o personagem errar seu ataque devido à camuflagem ou escuridão, poderá jogar novamente a porcentagem de chance de acerto. Quando não puder enxergar, o personagem sofrerá apenas metade da penalidade em seu deslocamento. Escuridão e baixa visibilidade reduzem seu deslocamento em três quartos, e não pela metade.',
  ),
  Talento(
    nome: 'Mestre em Perícia',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você é uma das maiores autoridades vivas em uma determinada perícia. Você consegue fazer o que por vezes parece impossível.\n Pré-requisitos: Especialização em Perícia, Especialização Aprimorada em Perícia, Especialização Avançada em Perícia, personagem de 15º nível ou maior.\nBenefícios: o personagem designa uma perícia que já tenha escolhido para ser afetada pelo talento Especialização Avançada em Perícia. O bônus que ele recebe será +7 ao invés de +5. O personagem também pode escolher 20 em perícias que normalmente não permitem isso e, quando o faz, leva apenas a metade do tempo para fazer o teste.\nEspecial: um personagem só pode escolher esse talento uma vez, para uma única perícia.',
  ),
  Talento(
      nome: 'Meticuloso',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          "Você é extremamente detalhista no que faz.\n Benefício: o personagem recebe um bônus de +2 em todos os testes de Falsificação e Procurar.",
      bonus: [
        Bonus(
            bonus: 2,
            atributo: 'Falsificação',
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            isActive: true,
            isPericia: true),
        Bonus(
            bonus: 2,
            atributo: 'Procurar',
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            isActive: true,
            isPericia: true)
      ]),
  Talento(
      nome: 'Mira Apurada',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Seus tiros com armas de longa distância têm precisão mortal. \nBenefício: antes de fazer um ataque à distância, o personagem pode usar uma ação de rodada completa para mirar no alvo. Isto garante um bônus de circunstância de +2 em sua próxima jogada de ataque. Uma vez que o personagem comece a mirar, não pode mais se mover nem mesmo um passo até seu próximo ataque, caso contrário o benefício do talento é perdido. Do mesmo modo, se a concentração do personagem é quebrada ou se ele for atacado antes de sua próxima ação, perde o benefício da mira.',
      requerimentos: 'Pré-Requisitos: Sabedoria 13, Tiro Longo.'),
  Talento(
    nome: 'Mobilidade',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    requerimentos: 'Pré-Requisitos: Destreza 13, Esquiva.',
    descricao:
        'Seu treinamento permite que você consiga desviar de seus oponentes evitando seus ataques. \nBenefício: o personagem recebe um bônus de esquiva de +4 na Defesa contra ataques de oportunidade provocados quando se move para fora de uma área ameaçada. \nEspecial: uma condição que faz o personagem perder deu bônus de Destreza na Defesa também faz com que perca seus bônus de esquiva. Além disso, bônus de esquiva se acumulam uns com os outros, ao contrário de outros tipos de bônus.',
  ),
  Talento(
      nome: "Nocaute",
      descricao:
          'Suas habilidades de combate o tornam capaz de nocautear seus oponentes. \nBenefício: quando um personagem faz seu primeiro ataque desarmado contra um oponente surpreendido, um ataque bem-sucedido é tratado como um sucesso decisivo. O dano é considerado não-letal. \nEspecial: mesmo que o personagem tenha a habilidade de considerar dano desarmado como dano letal, o dano de um nocaute é sempre considerado não-letal.',
      requerimentos: 'Pré-Requisitos: Briga, Bônus Base de Ataque +3.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Nocaute Aprimorado',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Suas incríveis habilidades de combate o tornam extremamente capaz de nocautear seus oponentes. \nBenefício: quando um personagem faz seu primeiro ataque desarmado contra um oponente surpreendido, um ataque bem-sucedido é tratado como um sucesso decisivo. Este sucesso decisivo causa dano triplo. O dano é considerado não-letal. \nEspecial: mesmo que o personagem tenha a habilidade de con- siderar dano desarmado como dano letal, o dano de um nocaute é sempre considerado não-letal.',
      requerimentos:
          'Pré-Requisitos: Briga, Nocaute, Bônus Base de Ataque +6.'),
  Talento(
      nome: 'Perito em Eletrônica',
      descricao:
          "Você tem um talento natural para lidar com máquinas. \nBenefício: o personagem recebe um bônus de +2 em todos os testes de Usar Computador e Reparos. \nEspecial: as perícias Usar Computador e Reparos só podem ser usadas sem treinamento em situações específicas.",
      bonus: [
        Bonus(
          bonus: 2,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          isActive: true,
          atributo: 'Usar Computador',
          isPericia: true,
        ),
        Bonus(
          bonus: 2,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          isActive: true,
          atributo: 'Reparos',
          isPericia: true,
        )
      ]),
  Talento(
      nome: 'Pilotar Aeronave',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      descricao:
          'Selecione uma classe de aeronave (Veículo Aéreo Pesado, Helicópteros, Caças e Espaçonaves). O personagem é capaz de operar a classe de veículo aéreo escolhida. Veículos Aéreos Pesados incluem aviões jumbo, grandes aviões de carga, bombardeiros pesados e qualquer outro veículo aéreo com três ou mais motores. Helicópteros incluem helicópteros de transporte e combate de todos os tipos. Caças incluem caças militares e caças ar-terra. Espaçonaves são veículos como o ônibus espacial e módulo lunar. \nBenefício: o personagem não sofre penalidades em testes de Pilotar ou jogadas de ataque quando estiver operando uma aeronave da classe selecionada. \nNormal: personagens sem este talento sofrem uma penalidade de –4 em testes de Pilotar realizados ao operar uma aeronave que se encaixe em uma dessas categorias e em ataques feitos com armas de aeronaves. A penalidade não se aplica quando o personagem está operando uma aeronave genérica. \nEspecial: o personagem pode adquirir este talento múltiplas vezes. Ele escolhe uma nova classe de aeronave cada vez que adquirir o talento.',
      requerimentos: 'Pré-requisitos: 4 graduações em Pilotar.'),
  Talento(
    nome: 'Precisão',
    descricao:
        'Você é capaz de atirar usando armas de longa distância com grande precisão. \nBenefício: o personagem pode atirar ou usar armas de arremesso contra um oponente envolvido em combate corpo-a-corpo sem penalidade. \nNormal: o personagem sofre uma penalidade de –4 ao usar uma arma de combate à distância para atacar um oponente envolvido em um combate corpo-a-corpo.',
    requerimentos: ' Tiro Certeiro.',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
  ),
  Talento(
      nome: 'Presença Aterradora',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      requerimentos: ' Carisma 15, 9 graduações em Intimidar.',
      descricao:
          "Você é capaz de intimidar as pessoas à sua volta meramente com a sua presença. \nBenefício: quando você usa este talento, todos os oponentes a até 3m de distância, com menos níveis que você, precisam fazer um teste de Vontade (CD 10 + ½ nível do personagem + modificador de Carisma do personagem). Um oponente que falha no teste fica abalado, sofrendo uma penalidade de –2 nas jogadas de ataque, testes de resistência e testes de perícias por um número de rodadas igual a 1d6 + modificador de Carisma do personagem. O personagem pode usar este talento uma vez por rodada como uma ação livre. Um teste de resistência bem-sucedido indica que o oponente é imune ao uso deste talento pelo personagem por 24 horas. Este talento não afeta criaturas com Inteligência 3 ou menor. Se o personagem possuir o talento Renome, a CD do teste de Resistência de Vontade sobe +5."),
  Talento(
      nome: "Prontidão",
      descricao:
          'Seus sentidos são mais apurados que o normal.\nBenefício: o personagem recebe um bônus de +2 em todos os testes de Ouvir e Observar.',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      bonus: [
        Bonus(
          bonus: 2,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          isActive: true,
          atributo: 'Observar',
          isPericia: true,
        ),
        Bonus(
          bonus: 2,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          isActive: true,
          atributo: 'Ouvir',
          isPericia: true,
        )
      ]),
  Talento(
    nome: 'Prosperidade',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você tem uma renda maior do que a média para a sua ocupação. \nBenefício: o personagem recebe um bônus de +3 em seu modificador de Renda. Além disso, este talento concede um bônus de +1 em todos os testes de Profissão. \nEspecial: o personagem pode escolher este talento várias vezes. Seus efeitos se acumulam.',
  ),
  Talento(
    nome: 'Rajada de Balas',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Com armas automáticas você é capaz de disparar rajadas curtas contra um único alvo. \nBenefício: quando estiver usando uma arma de fogo automática carregada com pelo menos cinco balas, o personagem pode atirar uma rajada curta como um único ataque contra um único inimigo. O personagem sofre uma penalidade de –4 na jogadas de ataque, mas recebe +2 dados de dano. Disparar uma rajada gasta cinco balas, e só pode ser feito com uma arma carregada com cinco balas. Normal: atirar com fogo automático gasta dez balas, atinge uma área de 3x3m, e não pode ter um alvo específico. Sem este talento, se o personagem tenta um ataque com tiro automático contra um alvo específico, ele conta como um ataque normal e as balas extras são perdidas. \nEspecial: se a arma de fogo tem ajuste para disparar uma rajada de três balas, atirar uma rajada gasta três balas ao invés de cinco, e pode ser usada apenas se a arma tiver três balas.',
    requerimentos: 'Pré-Requisitos: Sabedoria 13, Usar Armas de Fogo Pessoais',
  ),
  Talento(
    nome: 'Rastrear',
    created_at: DateTime.now(),
    updated_at: DateTime.now(),
    descricao:
        'Você recebeu treinamento para seguir rastros de criaturas e pessoas em uma grande variedade de terrenos diferentes. \nBenefício: encontrar ou seguir rastros por um quilômetro e meio requer um teste de Sobrevivência. O personagem precisa fazer outro teste de Sobrevivência cada vez que o rastro se torna mais difícil de seguir. O personagem se move metade de seu deslocamento normal; ou com seu deslocamento normal, sofrendo uma penalidade de –5 no teste; ou até duas vezes seu deslocamento normal, sofrendo uma penalidade de –20 no teste. A CD depende da superfície e condições \nprevalecentes: \nSolo muito macio (CD 5): qualquer superfície (neve fresca, poeira, lama) que mantenha as pegadas profundas e visíveis. \nSolo macio (CD 10): qualquer superfície mais firme que lama ou neve fresca, macia o suficiente para ceder à pressão, onde a criatura deixe pegadas freqüentes, porém rasas. \nSolo firme (CD 15): a maioria das superfícies externas normais (gramados, campos, florestas...) ou interiores excepcionalmente macios ou sujos (tapete grosso, chão muito sujo). A criatura pode deixar alguns rastros (galhos quebrados, tufos de pelo...) e só deixa uma pegada ocasionalmente. \nSolo duro (CD 20): qualquer superfície que não deixe pegadas, como rocha ou piso de interiores. A maioria das beiradas de rio entra nessa categoria, pois qualquer pegada fica obscurecida ou é apagada. \nA criatura só deixa alguns traços (pequenas marcas, pedras movidas). \nAqui estão alguns modificadores para CDs de testes de Rastrear: \n• Cada três criaturas no grupo sendo rastreado: CD–1. \n• Alvo de tamanho Minúsculo*: CD+8. \n• Alvo de tamanho Mínimo: CD+4. \n• Alvo de tamanho Miúdo: CD+2. \n• Alvo de tamanho Pequeno: CD+1. \n• Alvo de tamanho Médio: CD+0. \n• Alvo de tamanho Grande: CD–1. \n• Alvo de tamanho Enorme: CD–2. \n• Alvo de tamanho Imenso: CD–4. \n• Alvo de tamanho Colossal: CD–8. \n• Cada 24 horas depois que o rastro foi feito: CD+1. \n• Cada hora de chuva depois que o rastro foi feito: CD+1. \n• Neve cobrindo o rastro: CD+10. \n• Noite sem lua ou nublada: CD+6. \n• Apenas sob luz da lua: CD+3. \n• Sob neblina ou chuvisco: CD+3. \n• O alvo tenta ativamente esconder a própria trilha (movendo-se com metade de seu deslocamento): CD+5. \n* Para um grupo com tamanho misto, aplique somente o modificador da maior categoria de tamanho.',
  ),
  Talento(
      nome: 'Recarregar Rápido',
      descricao:
          'Você é capaz de recarregar sua arma muito mais rapidamente que o normal. \nBenefício: para um personagem com este talento, recarregar uma arma de fogo com um pente de balas já cheio ou com um recarregador rápido é uma ação livre. Recarregar um revólver sem um recarregador rápido ou recarregar qualquer arma de fogo com pente interno é considerado uma ação de movimento. Normal: recarregar uma arma de fogo com um pente de balas já cheio ou um recarregador rápido é uma ação de movimento. Recarregar um revólver sem um recarregador rápido ou recarregar qualquer arma de fogo com pente interno é uma ação de rodada completa.',
      requerimentos: 'Pré-Requisito: Bônus Base de Ataque +1.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Reflexos Em Combate',
      descricao:
          'Você consegue reagir rapidamente contra oponentes com a guarda baixa. \nBenefício: o número máximo de ataques de oportunidade que o personagem pode fazer a cada rodada é igual a seu modificador de Destreza +1. Você continua podendo fazer somente um ataque de oportunidade contra um mesmo oponente. \nNormal: um personagem sem este talento pode realizar apenas um ataque de oportunidade por rodada, e não pode fazer ataques de oportunidade se for surpreendido.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Reflexos Rapidos',
      descricao:
          "Seus reflexos são muito mais rápidos que o normal. \nBenefício: o personagem recebe um bônus de +2 em todos os testes de Reflexos.",
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      bonus: [
        Bonus(
            bonus: 2,
            atributo: 'Reflexo',
            created_at: DateTime.now(),
            updated_at: DateTime.now(),
            isPericia: true,
            isActive: true)
      ]),
  Talento(
      nome: 'Renome',
      descricao:
          'Graças à sua reputação, você tem mais chances de ser reconhecido. \nBenefício: aumenta a Reputação do personagem em 3 pontos.',
      created_at: DateTime.now(),
      updated_at: DateTime.now()),
  Talento(
      nome: 'Resposta Rápida',
      descricao:
          ' Você é capaz de contra-atacar com eficiência assim que um oponente o ataca. \nBenefícios: uma vez por rodada, se o oponente que você designou como seu alvo de esquiva (veja o talento Esquiva) faz um ataque corpo-a-corpo e erra, você pode fazer um ataque de oportunidade com uma arma corpo-a-corpo contra este oponente. Determine e aplique os efeitos de ambos os ataques simultaneamente. \nMesmo um personagem com o talento Reflexos de Combate não pode usar o talento Resposta Rápida mais de uma vez por rodada. Este talento não garante mais ataques de oportunidade que o personagem teria normalmente em uma rodada.',
      created_at: DateTime.now(),
      updated_at: DateTime.now(),
      requerimentos: 'Pré-requisitos: Destreza 13, Esquiva'),
];
