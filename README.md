# Tekscripts UIX: Documentação Ofc

---

## Inicialização da Biblioteca

Para utilizar a Tekscripts UIX, insira este código no início do seu script:

```lua
-- Inicialização da UI
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/main.lua"))()
```

---

## Configuração do Botão Flutuante Principal

### Tekscripts:FloatButtonEdit
Permite personalizar o botão flutuante que abre/fecha a interface.

```lua
Tekscripts:FloatButtonEdit({
    Text = "Abrir Menu",  -- String | Texto exibido no botão flutuante
    Icon = "menu"         -- String | Nome do ícone exibido à esquerda (ícones disponíveis na biblioteca)
})
```

---

## Criação da Janela Principal

### Tekscripts.new
Cria a janela principal da interface (Window). Todos os outros componentes devem ser adicionados dentro dela.

```lua
local MeuPainel = Tekscripts.new({
    Name         = "Meu Painel",                  -- String  | Título da janela
    FloatText    = "Abrir Painel",                -- String  | Texto do botão flutuante (se não usar FloatButtonEdit)
    startTab     = "auto",                        -- String  | Nome da aba inicial ou "auto" para a primeira criada
    iconId       = "rbxassetid://105089076803454",-- String  | ID do ícone da janela (opcional)
    Transparent  = true,                          -- Boolean | Ativa fundo transparente
    Transparency = 0.5,                           -- Number  | Nível de transparência (0 a 1)
    LoadScreen   = true,                          -- Boolean | Exibe tela de carregamento ao iniciar
    Loading      = {                              -- Table   | Configurações da tela de carregamento
        Title = "TekScripts",
        Desc  = "By: Kauam"
    },
})
```

---

## Gerenciamento de Abas (Tabs)

### MeuPainel:CreateTab
Cria uma nova aba lateral na interface.

```lua
local MinhaAba = MeuPainel:CreateTab({
    Title = "Minha Aba"  -- String | Nome exibido na barra lateral
})
```

### Métodos da Aba
- `:Destroy()` – Remove a aba e limpa todas as conexões.
- `Tekscripts:SetActiveTab(MinhaAba)` – Força a exibição de uma aba específica via script.

---

## Componente: Toggle

### Parâmetros de Criação
| Parâmetro       | Tipo      | Descrição                                              | Obrigatório? |
|-----------------|-----------|--------------------------------------------------------|--------------|
| Text            | string    | Título principal exibido no toggle                     | Sim          |
| Desc            | string?   | Descrição detalhada abaixo do título (opcional)        | Não          |
| Callback        | function  | Função chamada ao alterar o estado (recebe boolean)    | Sim          |
| Type            | string?   | Estilo: "Toggle" (padrão) ou "CheckBox"                 | Não          |
| FeedbackDebug   | boolean?  | Se true, exibe tremor e borda vermelha em caso de erro  | Não          |

### Exemplo
```lua
local meuToggle = MeuPainel:CreateToggle(MinhaAba, {
    Text = "Velocidade Máxima",
    Desc = "Aumenta a velocidade do personagem",
    Type = "Toggle",
    FeedbackDebug = true,
    Callback = function(state)
        print("Estado do Toggle:", state)
    end
})

meuToggle:SetState(true)  -- Define estado manualmente sem chamar callback
```

### Métodos do Toggle
| Método             | Descrição                                           |
|--------------------|-----------------------------------------------------|
| :SetState(bool)    | Altera o estado visual sem disparar o callback      |
| :GetState()        | Retorna o valor atual (true/false)                  |
| :SetLocked(bool)   | Bloqueio administrativo (ex: funções VIP)           |
| :SetBlocked(bool)  | Bloqueio temporário para evitar spam                |
| :PulseError()      | Exibe efeito visual de erro (tremor)                |
| :Destroy()         | Remove o componente da memória                       |

> **Dica:** Use `:SetLocked` para itens pagos/VIP. Use `:SetBlocked` durante processamento pesado.

---

## Componente: Slider

### Exemplo
```lua
local MeuSlider = MeuPainel:CreateSlider(MinhaAba, {
    Text     = "WalkSpeed",
    Min      = 16,
    Max      = 100,
    Step     = 1,
    Value    = 16,
    Callback = function(valor)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = valor
    end
})
```

### Métodos do Slider
| Método               | Descrição                                           |
|----------------------|-----------------------------------------------------|
| :Get()               | Retorna o valor atual                               |
| :Set(valor)          | Define um novo valor                                |
| :GetPercent()        | Retorna o percentual (0 a 1)                         |
| :SetRange(min, max, step) | Altera os limites dinamicamente                |
| :AnimateTo(valor, tempo) | Move o slider suavemente até um valor            |
| :OnChanged(funcao)   | Adiciona listener extra para mudanças               |
| :Update(tabela)      | Atualiza múltiplas propriedades de uma vez          |

---

## Componente: TextBox (Log ou Input)

### Exemplo
```lua
local logBox = MeuPainel:CreateTextBox(MinhaAba, {
    Text     = "Console de Logs",
    Desc     = "Histórico de eventos",
    Default  = "Iniciando sistema...\n",
    ReadOnly = true  -- Impede edição pelo usuário
})
```

### Métodos
| Método       | Descrição                              |
|--------------|----------------------------------------|
| :SetText(str)| Substitui todo o conteúdo              |
| :GetText()   | Retorna o texto atual                  |
| :Append(str) | Adiciona texto ao final                 |
| :Clear()     | Limpa todo o conteúdo                  |
| :Destroy()   | Remove o componente                    |

---

## Componente: Bind (Vinculação de Tecla)

### Parâmetros
| Parâmetro  | Tipo       | Descrição                                          | Obrigatório? |
|------------|------------|----------------------------------------------------|--------------|
| Text       | string     | Título do componente                               | Sim          |
| Desc       | string?    | Descrição (opcional)                               | Não          |
| Default    | Enum.KeyCode | Tecla padrão (ex: Enum.KeyCode.F)                | Sim          |
| Callback   | function   | Executada ao pressionar a tecla (recebe KeyCode)   | Sim          |

### Exemplo
```lua
local MeuBind = MeuPainel:CreateBind(MinhaAba, {
    Text     = "Ativar Kill Aura",
    Desc     = "Pressione a tecla para alternar",
    Default  = Enum.KeyCode.F,
    Callback = function(tecla)
        print("Tecla pressionada:", tecla.Name)
    end
})
```

### Métodos
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :GetKey()         | Retorna a tecla atual                          |
| :SetKey(Enum.KeyCode) | Define nova tecla manualmente               |
| :Listen()         | Entra em modo de espera por nova tecla         |
| :Update(tabela)   | Atualiza texto, descrição ou tecla             |
| :Destroy()        | Remove e limpa conexões de input                |

---

## Componente: Dropdown

### Parâmetros
| Parâmetro         | Tipo    | Descrição                                                  | Obrigatório? |
|-------------------|---------|------------------------------------------------------------|--------------|
| Title             | string  | Título do dropdown                                         | Sim          |
| Values            | table   | Lista de { Name = string, Image = string? }                 | Sim          |
| MultiSelect       | boolean?| Permite seleção múltipla                                   | Não          |
| MaxVisibleItems   | number? | Máximo de itens visíveis antes da rolagem (máx 8)           | Não          |
| InitialValues     | table?  | Itens selecionados inicialmente                             | Não          |
| Callback          | function| Recebe string (única) ou table (múltipla)                  | Sim          |

### Exemplo
```lua
local MeuDropdown = MeuPainel:CreateDropdown(MinhaAba, {
    Title         = "Escolha o Mapa",
    Values        = {
        { Name = "Deserto", Image = "rbxassetid://123456" },
        { Name = "Floresta", Image = "rbxassetid://789012" },
        { Name = "Neve" }
    },
    MultiSelect   = false,
    MaxVisibleItems = 5,
    InitialValues = {"Deserto"},
    Callback      = function(selecionado)
        print("Selecionado:", selecionado)
    end
})
```

### Métodos
| Método             | Descrição                                      |
|--------------------|------------------------------------------------|
| :GetSelected()     | Retorna seleção atual                          |
| :SetSelected(val)  | Define seleção via script                      |
| :AddItem(info, pos)| Adiciona item dinamicamente                    |
| :RemoveItem(nome)  | Remove item pelo nome                          |
| :ClearItems()      | Remove todos os itens                          |
| :Toggle() / :Close() | Abre ou fecha o menu                         |
| :Destroy()         | Remove completamente                           |

---

## Componente: Dialog (Janela Modal)

### Exemplo
```lua
MeuPainel:CreateDialog({
    Title   = "Aviso do Sistema",
    Message = "Você tem certeza que deseja resetar?",
    Buttons = {
        { Text = "Cancelar", Callback = function() print("Cancelado") end },
        { Text = "Confirmar", Callback = function() print("Confirmado") end }
    }
})
```

### Métodos
- `:Destroy()` – Fecha e limpa o diálogo.

> **Nota:** Dialogs são criados diretamente no PlayerGui e bloqueiam interação com o fundo.

---

## Componente: Input (Campo de Texto/Número)

### Parâmetros
| Parâmetro    | Tipo    | Descrição                                          | Obrigatório? |
|--------------|---------|----------------------------------------------------|--------------|
| Text         | string  | Título do campo                                    | Sim          |
| Placeholder  | string? | Texto de sugestão quando vazio                      | Não          |
| Desc         | string? | Descrição abaixo do campo                          | Não          |
| Type         | string? | "string" (padrão) ou "number"                      | Não          |
| BlockText    | string? | Texto exibido quando bloqueado                     | Não          |
| Callback     | function| Executada ao confirmar (Enter ou perda de foco)    | Sim          |

### Métodos
| Método               | Descrição                                      |
|----------------------|------------------------------------------------|
| :SetBlocked(bool, texto) | Bloqueia/desbloqueia com overlay             |
| :Update(tabela)      | Atualiza propriedades dinamicamente            |
| :Destroy()           | Remove o componente                            |

---

## Componente: Button

### Exemplo
```lua
local MeuBotao = MeuPainel:CreateButton(MinhaAba, {
    Text     = "Executar Script",
    Debounce = 0.5,  -- Tempo mínimo entre cliques
    Callback = function()
        print("Botão clicado!")
    end
})
```

### Métodos
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :SetBlocked(bool) | Desativa interação e muda aparência             |
| :Update(tabela)   | Atualiza texto, callback ou debounce           |
| :Destroy()        | Remove e limpa eventos                         |

---

## Componente: FloatButton (Botão Flutuante Independente)

### Parâmetros
| Parâmetro | Tipo     | Descrição                                          | Obrigatório? |
|-----------|----------|----------------------------------------------------|--------------|
| Text      | string   | Texto principal do botão                           | Sim          |
| Title     | string?  | Texto do cabeçalho de arrasto                      | Não          |
| Drag      | boolean? | Permite arrastar (padrão: true)                    | Não          |
| Visible   | boolean? | Visibilidade inicial (padrão: true)                | Não          |
| Pos       | UDim2?   | Posição inicial na tela                            | Não          |
| Callback  | function | Executada ao clicar                                | Sim          |

### Métodos
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :SetText(str)     | Altera texto principal                         |
| :SetTitle(str)    | Altera texto do cabeçalho                      |
| :SetVisible(bool) | Mostra/oculta                                  |
| :SetBlock(bool)   | Bloqueia interação                             |
| :Destroy()        | Remove completamente                           |

---

## Sistema: Localization (Tradução Dinâmica)

### Configuração Inicial
```lua
Tekscripts.Localization:Init({
    ["en"] = {
        ["welcome"] = "Welcome to Tekscripts",
        ["speed"]   = "Walk Speed"
    },
    ["pt"] = {
        ["welcome"] = "Bem-vindo ao Tekscripts",
        ["speed"]   = "Velocidade de Caminhada"
    }
})

Tekscripts.Localization:SetLanguage("pt")
```

### Métodos
| Método                  | Descrição                                      |
|-------------------------|------------------------------------------------|
| :Init(tabela)           | Inicializa traduções                           |
| :SetLanguage(lang)      | Muda idioma global                             |
| :GetLanguage()          | Retorna idioma atual                           |
| :SetTranslations(lang, tabela) | Atualiza traduções de um idioma          |
| :Get("loc:chave")       | Retorna texto traduzido                        |
| :SetEnabled(bool)       | Ativa/desativa o sistema                       |

> **Recomendação:** Inicialize a localização logo após carregar a biblioteca.

---

## Componente: Section (Seção Expansível)

### Exemplo
```lua
local MinhaSecao = MeuPainel:CreateSection(MinhaAba, {
    Title = "Configurações de Combate",
    Open  = true,
    Fixed = false
})

MinhaSecao:AddComponent(meuToggle, meuSlider, meuBotao)
```

### Métodos
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :AddComponent(...) | Adiciona componentes à seção                  |
| :SetTitle(str)    | Altera título                                  |
| :Open() / :Close() / :Toggle() | Controla estado aberto/fechado         |
| :Block(bool, msg) | Bloqueia com mensagem                          |
| :Destroy()        | Remove seção e todos os componentes internos   |

---

## Componente: TabContainer (Sub-abas Horizontais)

### Exemplo
```lua
local Container = MeuPainel:CreateTabContainer(MinhaAba, {
    Title         = "Configurações Avançadas",
    TabBarHeight  = 45
})

local AbaGeral     = Container:AddTab("Geral")
local AbaSeguranca = Container:AddTab("Segurança")

local toggle = MeuPainel:CreateToggle(AbaGeral, { Text = "Auto Farm", Callback = function(v) print(v) end })
AbaGeral:AddComponent(toggle)
```

### Métodos do Container
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :AddTab(nome)     | Cria e retorna nova sub-aba                    |
| :SwitchTo(nome)   | Muda para aba especificada                     |

### Métodos da Sub-aba
| Método            | Descrição                                      |
|-------------------|------------------------------------------------|
| :AddComponent(...) | Move componentes para dentro dela             |

---

## Componente: Label

### Exemplo
```lua
local MinhaLabel = MeuPainel:CreateLabel(MinhaAba, {
    Title       = "Status do Servidor",
    Desc        = "Operando normalmente com 15 players",
    Image       = "http://sua-url.com/imagem.png",  -- ou rbxassetid://
    imageGround = "medium",  -- "min", "medium" ou "max"
    Color       = Color3.fromRGB(255, 255, 255)
})
```

### Métodos
| Método              | Descrição                                      |
|---------------------|------------------------------------------------|
| :SetText(str)       | Atualiza título                                |
| :SetDescription(str)| Atualiza descrição                             |
| :SetImage(url/id)   | Carrega nova imagem (com cache)                 |
| :SetVisible(bool)   | Mostra/oculta                                  |

---

## Componente: Divider (Separador Visual)

### Exemplo
```lua
MeuPainel:CreateDivider(MinhaAba, {
    Text   = "CONFIGURAÇÕES DE COMBATE",
    Color  = Color3.fromRGB(40, 40, 45),
    Height = 30
})
```

### Métodos
- `:SetText(str)` – Atualiza o título dinamicamente.

---
