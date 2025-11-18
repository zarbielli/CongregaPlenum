# CongregaPlenum

CongregaPlenum é uma gem Ruby voltada para integrações com os dados abertos da Câmara
dos Deputados. Ela encapsula HTTP, paginação, retries e log em serviços
especializados (deputados, partidos e legislaturas), expondo uma API Ruby
consistente e segura para aplicações de sincronização ou dashboards.

## Instalação

Adicione ao seu `Gemfile`:

```ruby
gem 'congrega_plenum', github: 'NOME_ORGANIZACAO/congrega_plenum'
```

Ou via linha de comando:

```bash
bundle add congrega_plenum --github NOME_ORGANIZACAO/congrega_plenum
```

Depois disso rode `bundle install`.

## Configuração

Toda configuração é centralizada em `CongregaPlenum.configure`:

```ruby
CongregaPlenum.configure do |config|
  config.base_url = 'https://dadosabertos.camara.leg.br/api/v2'
  config.timeout = 20
  config.retries = 5
  config.logger = Logger.new($stdout)
end
```

Os valores padrão já apontam para os endpoints oficiais, com timeouts e retries
ajustados para o comportamento atual da API.

## Uso

Exemplo básico coletando todos os deputados da legislatura corrente:

```ruby
deputados = CongregaPlenum::CongressmenService.fetch_all_by_legislature(57)

deputados.each do |deputado|
  puts "#{deputado['ultimoStatus']['nomeEleitoral']} - #{deputado['id']}"
end
```

Outros fluxos disponíveis:

- `CongregaPlenum::CongressmenService.fetch_list(page:, items_per_page:, legislature_id:)`
- `CongregaPlenum::PartiesService.fetch_all`
- `CongregaPlenum::LegislaturesService.fetch_mesa(legislature_id)`

Caso precise de um controle mais fino, use diretamente `CongregaPlenum::Client`.

## Documentação

Para gerar a documentação em RDoc execute:

```bash
bundle exec rake rdoc
```

Os arquivos HTML serão criados em `doc/`. Abra `doc/index.html` no navegador para consultar as classes, módulos e métodos disponíveis.

## Development

1. `bin/setup` instala dependências.
2. `bundle exec rspec` roda a suíte (SimpleCov gera `coverage/index.html`).
3. `bundle exec steep check` valida as assinaturas RBS.
4. `bundle exec rubocop` garante estilo consistente.

Para publicar localmente:

```bash
bundle exec rake install
```

Ou para liberar uma versão (ajuste `lib/version.rb` antes):

```bash
bundle exec rake release
```

## Contribuindo

Issues e pull requests são bem-vindos. Abra um PR com:

- Descrição do problema/feature
- Cobertura de testes (RSpec)
- Atualização de documentação se necessário

Vamos manter o padrão de logs em português e comentários explicando o *porquê* das
decisões. Ajustes são muito bem-vindos!
