# FaturaX

Aplicativo Flutter para controle de gastos mensais. Registre compras parceladas e assinaturas, acompanhe o total do mês atual e veja o ranking de gastos entre todos os usuários.

## Funcionalidades

- **Autenticação** — cadastro e login via Firebase Auth
- **Registro de compras** — adicione gastos com nome, valor e tipo:
  - **Parcelada**: define o número de parcelas e a data de início
  - **Assinatura/Fixa**: cobrança recorrente sem data de encerramento
- **Total do mês** — calcula automaticamente o valor ativo no mês corrente, considerando parcelas pagas e contratos vigentes
- **Ranking** — lista todos os usuários com seus totais acumulados em tempo real
- **Verificação de conexão** — exibe tela de erro ao perder acesso à internet

## Tecnologias

| Camada | Tecnologia |
|---|---|
| Framework | Flutter 3 / Dart 3 |
| Backend | Firebase (Auth + Firestore) |
| Estado | Provider |
| Localização | pt_BR (flutter_localizations + intl) |
| Fontes | Google Fonts (Figtree) |

## Pré-requisitos

- Flutter SDK `^3.11.5`
- Conta no Firebase com projeto configurado
- Android SDK (min SDK 23)

## Configuração

1. Clone o repositório e instale as dependências:
   ```bash
   flutter pub get
   ```

2. Configure o Firebase:
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com)
   - Ative **Authentication** (e-mail/senha) e **Firestore**
   - Gere o arquivo `google-services.json` e coloque em `android/app/`
   - O arquivo `lib/firebase_options.dart` já está configurado para o projeto atual

3. Execute o app:
   ```bash
   flutter run
   ```

## Estrutura do projeto

```
lib/
├── constants/        # Cores, valores e regex reutilizáveis
├── controller/       # Controllers (ex: verificador de internet)
├── core/             # Serviços base (auth_service, contratos)
├── models/           # Estado com ChangeNotifier (auth, produto, user, ranking)
├── ui/
│   ├── components/   # Slivers, inputs e widgets compostos
│   ├── pages/        # Telas (auth, home, items, ranking, profile)
│   └── widgets/      # Widgets genéricos reutilizáveis
└── utils/            # Lógica de negócio (salvar compra, utilitários)
```

## Estrutura do Firestore

```
users/{uid}
  ├── username: string
  ├── total: int          # total do mês em centavos
  └── items/{itemId}
        ├── name: string
        ├── price_int: int          # valor em centavos
        ├── isFixed: bool
        ├── parcelas_totais: int    # 0 se assinatura
        ├── parcelas_parciais: int
        ├── start_date: string
        ├── month: int
        ├── year: int
        └── timestamp: int
```

## Versão

`v1.2`
