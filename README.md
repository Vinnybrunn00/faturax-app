# FaturaX

Aplicativo de controle de compras e assinaturas pessoais, desenvolvido em Flutter com Firebase.

---

## Sobre o projeto

O FaturaX permite registrar compras parceladas e assinaturas recorrentes, acompanhando o progresso de pagamento de cada item em tempo real. O objetivo é dar visibilidade sobre quanto você gasta por mês e o que ainda está por vir.

---

## Funcionalidades

- Autenticação de usuários (email e senha via Firebase Auth)
- Cadastro de compras parceladas e assinaturas fixas
- Acompanhamento de parcelas pagas e restantes
- Previsão de gastos para o mês seguinte
- Ranking de gastos por categoria
- Suporte offline com feedback visual de conexão
- Interface em português do Brasil

---

## Tecnologias

| Camada | Tecnologia |
|---|---|
| Framework | Flutter 3.12+ |
| Linguagem | Dart |
| Autenticação | Firebase Auth |
| Banco de dados | Cloud Firestore |
| Estado | Provider |
| Tipografia | Google Fonts (Figtree) |
| Localização | flutter_localizations (pt_BR) |
| Deploy | Shorebird |

---

## Arquitetura

O projeto segue o padrão **MVVM** com Provider para injeção de dependência e gerenciamento de estado.

```
lib/
├── constants/        # Cores, valores e regex globais
├── controller/       # Controllers de UI (scroll, internet)
├── core/             # Serviços de autenticação e contratos
├── models/           # Modelos de dados (compras, auth)
├── repository/       # Acesso ao Firestore
├── ui/
│   ├── components/   # Inputs e slivers reutilizáveis
│   ├── helpers/      # Utilitários de UI (snackbars, etc)
│   ├── modals/       # Bottom sheets
│   ├── pages/        # Telas do app
│   └── widgets/      # Widgets genéricos
└── viewmodels/       # Estado das telas
```

---

## Pré-requisitos

- Flutter SDK `^3.12.1`
- Dart SDK compatível
- Projeto Firebase configurado (Auth + Firestore)
- Android SDK mínimo: API 23

---

## Como rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/faturax_app.git
   cd faturax_app
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Configure o Firebase:
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com)
   - Adicione o arquivo `google-services.json` em `android/app/`
   - O arquivo `firebase_options.dart` já está configurado via FlutterFire CLI

4. Execute o app:
   ```bash
   flutter run
   ```

---

## Versão

`1.0.5`
