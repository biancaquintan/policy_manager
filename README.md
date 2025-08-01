# Policy Manager

Sistema simples para gerenciamento de apólices de seguro, desenvolvido em Ruby on Rails, com controle de acesso baseado em papéis para garantir permissões específicas:

- **Admin:** acesso completo — pode criar, visualizar, editar e excluir qualquer apólice.
- **Operador:** pode visualizar todas as apólices e criar novas.
- **Cliente:** pode apenas visualizar somente suas próprias apólices.

## Tecnologias Utilizadas

- Ruby 3.2.1
- Rails 7.1.5
- PostgreSQL

## Funcionalidades

- Controle de acesso via políticas Pundit aplicadas nas controllers.
- API JSON-only para todas as requisições.
- Testes automatizados com cobertura para diferentes papéis e ações.

## Como Rodar

1. Clone o repositório:

   ```bash
   git clone https://github.com/seuusuario/policy_manager.git
   cd policy_manager
   
2. Crie um arquivo .env na pasta raiz do projeto com os seguintes dados:

   ```bash
   POSTGRES_USER=
   POSTGRES_PASSWORD=
   POSTGRES_HOST=
   POSTGRES_PORT=
   DEVELOP_DATABASE_URL=
   TEST_DATABASE_URL=
   PROD_DATABASE_URL=

3. Popule o banco de dados:

   ```bash
   rails db:create db:migrate db:seed

4. Rode os testes:

   ```bash
   bundle exec rspec
