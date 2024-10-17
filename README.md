# Desafio Tractian

<img src="docs" alt="preview.gif">

Este projeto foi desenvolvido para gerenciar empresas, localizações e ativos (assets), usando uma arquitetura baseada em Clean Architecture com Flutter. Ele prioriza a separação de responsabilidades, seguindo os princípios de SOLID, com foco em escalabilidade e testabilidade.

### Arquitetura

1. Camadas

   **Apresentação (Presenter):** Gerencia a interação com o usuário, com Widgets e Controllers que acionam os casos de uso.
   **Domínio (Domain):** Contém as regras de negócio, como os Use Cases e os Repositórios (interfaces).
   **Dados (Data):** Acessa APIs e banco de dados local (SQLite) via repositórios implementados.


2. Processamento Assíncrono
   Utilizamos Isolates para realizar processamento pesado, como a conversão de dados recebidos da API antes de serem armazenados no banco de dados, garantindo uma interface responsiva.

3. Gerenciamento de Estado
   O gerenciamento de estado é feito de forma manual com setState() ou ValueNotifier, garantindo simplicidade, mas pronto para escalabilidade com soluções como Bloc ou Riverpod, se necessário.

4. Banco de Dados
   Usamos SQLite via sqflite, com suporte a batch processing para operações eficientes em lote.

5. Tratamento de Erros
   Os erros são tratados usando um padrão de Resource, encapsulando falhas e sucessos, seguindo uma abordagem funcional para garantir previsibilidade.

### Tecnologias

- Flutter (3.22.3): Framework para construção da interface do usuário.
- Sqflite: Biblioteca para interação com o banco de dados SQLite.
- Dio: Biblioteca para requisições HTTP.
- Isolates: Para processamento em segundo plano.
- GetIt: Para injeção de dependências.

### Execução e Configuração

Clone o repositório:

`git clone https://github.com/seu-repositorio.git`

Instale as dependências:

`flutter pub get`

Execute a aplicação:

`flutter run`

### Futuras Melhorias

- **Gerenciamento de estado:** Poderia ser melhorado com a implementação de uma solução mais robusta, como Riverpod ou Bloc, dependendo da escalabilidade do projeto.

- **Testes:** Testes unitários e de integração mais extensivos podem ser implementados em todas as camadas.

- **Caching avançado:** Implementar uma lógica de caching inteligente para otimizar o desempenho, sincronizando dados com a API quando necessário.

- *Sistema de temas:* Implementar um sistema de temas dinâmicos para permitir mudanças em tempo real no modo de exibição (claro/escuro) e ajuste de brilho. Isso traria mais flexibilidade e personalização para os usuários, permitindo que eles ajustem o visual da aplicação de acordo com suas preferências.

- **Internacionalização (i18n):** Introduzir a internacionalização (i18n) para suportar múltiplos idiomas no aplicativo. Atualmente, os textos são fixos e não oferecem suporte a outras regiões. Com essa melhoria, o app seria acessível a um público global, tornando-o mais inclusivo e expandindo seu alcance.

- **Otimização da logica de construção da arvore de assets:** Refatorar a lógica atual de construção da árvore de assets e locations para consultar os dados diretamente no banco de dados, evitando a lógica em loops como for que consome mais tempo e recursos. Essa mudança resultaria em melhor performance ao lidar com grandes quantidades de dados, especialmente quando o número de assets e locations for significativo.

- **Layout da arvore:** Melhorar a animação ao clicar no nó da arvore.

- **Gateway da api:** Adaptar para realizar outros metodos de requisições e tratar de forma geral os erros;
