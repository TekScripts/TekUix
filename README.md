# Tekscripts UIX: Documentação Oficial (v2025)

Bem-vindo à documentação da Tekscripts UIX. Abaixo você encontrará todos os métodos para inicialização e criação de componentes da biblioteca.

---

## Inicialização: init
Insira este trecho no início do seu código para carregar os componentes necessários da biblioteca.

```lua
-- > Inicialização da UI
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/main.lua"))()
```

---

## Gerenciamento da Janela

### Tekscripts:FloatButtonEdit
Edição abrangente do Float Button (botão flutuante para abrir/fechar a interface).

```lua
-- > Configura o botão flutuante principal
Tekscripts:FloatButtonEdit({
    Text = "Abrir Menu", -- > String | Nome que aparece no FloatButton
    Icon = "menu"        -- > String | Ícone exibido ao lado esquerdo
})
```

### Tekscripts.new
Criação da janela principal (Window). Essencial para hospedar todos os outros componentes.

```lua
-- > Criação do container principal com persistência visual
local MeuPainel = Tekscripts.new({
    Name = "Meu Script",                 -- > String  | Título do painel
    FloatText = "Abrir Painel",          -- > String  | Texto do botão flutuante
    startTab = "auto",                   -- > String  | Tab selecionada inicialmente
    iconId = "rbxassetid://105089076803454", -- > String  | ID do ícone da interface
    Transparent = true,                  -- > Boolean | Ativa transparência
    Transparency = 0.5,                  -- > Number  | Nível de transparência (0 a 1)
    LoadScreen = true,                   -- > Boolean | Ativa sistema de carregamento
    Loading = { 
        Title = "TekScripts", 
        Desc = "By: Kauam"
    },                                   -- > Array   | Configuração da tela de load
})
```

---

## Sistema: Localization
O módulo Localization permite a tradução dinâmica. Deve ser configurado logo após a inicialização.

```lua
-- > Configurando traduções e cache de idioma
Tekscripts.Localization:Init({
    ["en"] = {
        ["welcome"] = "Welcome to Tekscripts",
        ["speed"] = "Walk Speed"
    },
    ["pt"] = {
        ["welcome"] = "Bem-vindo ao Tekscripts",
        ["speed"] = "Velocidade de Caminhada"
    }
})

-- > Define idioma (pode ser carregado de um arquivo de config para persistência)
Tekscripts.Localization:SetLanguage("pt")
```

### API de Localização (Métodos)
| Método | Descrição |
| :--- | :--- |
| :Init(table) | Inicializa o sistema com uma tabela completa de traduções. |
| :SetLanguage(lang) | Altera o idioma global do sistema. |
| :GetLanguage() | Retorna o código do idioma selecionado no momento. |
| :Get(key) | Busca o valor traduzido de uma chave (ex: "loc:welcome"). |

---

## Gerenciamento de Abas (Tabs)

### Tekscripts:CreateTab
Cria uma nova seção lateral na interface.

```lua
-- > Criação de uma nova aba
local MinhaAba = MeuPainel:CreateTab({
    Title = "Minha Aba" -- > String
})
```

#### Métodos da Aba
* **Destruir Aba:** `MinhaAba:Destroy()` (Remove a aba e limpa conexões).
* **Alternar Aba:** `Tekscripts:SetActiveTab(MinhaAba)` (Força a visualização via script).

---

## Componente: Toggle

```lua
-- > Toggle com feedback de erro e estado inicial
local meuToggle = MeuPainel:CreateToggle(MinhaAba, {
    Text = "Velocidade Máxima",
    Desc = "Aumenta a velocidade do personagem",
    Type = "Toggle", -- "Toggle" ou "CheckBox"
    FeedbackDebug = true,
    Callback = function(state)
        -- > Lógica de persistência ou execução
        print("Estado do Toggle:", state)
    end
})

-- > Define estado manualmente para consistência de cache
meuToggle:SetState(true)
```

### API do Toggle (Métodos)
| Método | Descrição |
| :--- | :--- |
| :SetState(bool) | Altera o estado visual sem disparar o Callback. |
| :GetState() | Retorna o valor atual (true/false). |
| :SetLocked(bool) | Bloqueio Administrativo (ex: para funções VIP). |
| :SetBlocked(bool) | Bloqueio de Segurança (impede spam). |
| :PulseError() | Dispara efeito visual de erro (tremor). |
| :Destroy() | Remove o componente da memória. |

---

## Componente: Slider

```lua
-- > Slider para valores numéricos precisos
local MeuSlider = MeuPainel:CreateSlider(MinhaAba, {
    Text = "WalkSpeed",
    Min = 16,
    Max = 100,
    Step = 1,
    Value = 16,
    Callback = function(v)
        -- > Atualização direta de valor
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})
```

### API do Slider
| Método | Descrição |
| :--- | :--- |
| :Get() | Retorna o valor atual do Slider. |
| :Set(val) | Define um novo valor para o Slider. |
| :SetRange(min, max, step) | Altera os limites dinamicamente. |
| :AnimateTo(val, time) | Move o slider suavemente até um valor. |
| :Update(table) | Atualiza propriedades como Texto e Valor de uma vez. |

---

## Componente: TextBox (Log/Input)

```lua
-- > Box para logs ou exibição de textos longos
local logBox = MeuPainel:CreateTextBox(MinhaAba, {
    Text = "Console de Logs",
    Desc = "Histórico de eventos",
    Default = "Iniciando sistema...\n",
    ReadOnly = true -- > Define se o usuário pode editar
})

-- > Adicionando informação ao final
logBox:Append("Nova linha detectada.")
```

---

## Componente: Bind

```lua
-- > Vincula teclas a funções com tratamento de erro
local MeuBind = MeuPainel:CreateBind(MinhaAba, {
    Text = "Ativar Kill Aura",
    Desc = "Pressione a tecla para alternar o estado",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Bind pressionado! Tecla: " .. key.Name)
    end
})
```

### API do Bind (Métodos)
| Método | Descrição |
| :--- | :--- |
| :GetKey() | Retorna o Enum.KeyCode atual. |
| :SetKey(Enum.KeyCode) | Define uma nova tecla manualmente. |
| :Listen() | Ativa o modo de escuta para capturar nova tecla. |

---

## Componente: Dropdown

```lua
-- > Menu de seleção única ou múltipla
local MeuDropdown = MeuPainel:CreateDropdown(MinhaAba, {
    Title = "Escolha o Mapa",
    Values = {
        { Name = "Deserto", Image = "rbxassetid://123456" },
        { Name = "Floresta", Image = "rbxassetid://789012" },
        { Name = "Neve" }
    },
    MultiSelect = false,
    MaxVisibleItems = 5,
    InitialValues = {"Deserto"},
    Callback = function(selected)
        -- > selected será string (única) ou table (múltipla)
        print("Selecionado:", selected)
    end
})
```

### API do Dropdown (Métodos)
| Método | Descrição |
| :--- | :--- |
| :GetSelected() | Retorna o valor atual. |
| :SetSelected(values) | Define a seleção (string ou table). |
| :AddItem(valueInfo, pos) | Adiciona {Name, Image} na lista. |
| :RemoveItem(name) | Remove um item pelo nome. |
| :ClearItems() | Limpa toda a lista. |

---

## Componente: Dialog (Modal)

```lua
-- > Janela de confirmação (bloqueia o fundo)
local MeuDialog = MeuPainel:CreateDialog({
    Title = "Aviso do Sistema",
    Message = "Você tem certeza que deseja resetar suas configurações?",
    Buttons = {
        {
            Text = "Cancelar",
            Callback = function() -- > Fecha automaticamente após execução
                print("Cancelado")
            end
        },
        {
            Text = "Confirmar",
            Callback = function()
                print("Confirmado")
            end
        }
    }
})
```

---

## Componente: Input

```lua
-- > Campo para entrada de texto ou números
local MeuInput = MeuPainel:CreateInput(MinhaAba, {
    Text = "Nome do Item",
    Placeholder = "Digite aqui...",
    Desc = "Este nome será exibido no inventário",
    Type = "string", -- "string" ou "number"
    Callback = function(txt)
        print("Texto digitado: " .. txt)
    end
})

-- > Bloqueio visual para evitar interações indevidas
MeuInput:SetBlocked(true, "🔒 TRANCADO")
```

---

## Componente: Button

```lua
-- > Botão padrão com debounce interno (anti-spam)
local MeuBotao = MeuPainel:CreateButton(MinhaAba, {
    Text = "Executar Script",
    Debounce = 0.5, 
    Callback = function()
        print("Botão acionado!")
    end
})
```

---

## Componente: Section

```lua
-- > Agrupamento de componentes com controle de estado
local MinhaSecao = MeuPainel:CreateSection(MinhaAba, {
    Title = "Configurações de Combate",
    Open = true,
    Fixed = false
})

-- > Adicionando componentes à seção para organização hierárquica
MinhaSecao:AddComponent(meuToggle, MeuSlider)
```

### API da Section (Métodos)
| Método | Descrição |
| :--- | :--- |
| :AddComponent(...) | Vincula componentes existentes à seção. |
| :Open() / :Close() | Controla o estado de expansão. |
| :Block(bool, msg) | Bloqueia a interação de todo o grupo. |

---

## Componente: TabContainer (Sub-Abas)

```lua
-- > Criação de sistema de sub-abas dentro de uma aba principal
local SubSistema = MeuPainel:CreateTabContainer(MinhaAba, {
    Title = "Configurações Avançadas",
    TabBarHeight = 45
})

-- > Criação das sub-abas
local AbaGeral = SubSistema:AddTab("Geral")
local AbaSeguranca = SubSistema:AddTab("Segurança")

-- > IMPORTANTE: Para adicionar componentes à sub-aba:
local toggleFarm = MeuPainel:CreateToggle(AbaGeral, {
    Text = "Auto Farm",
    Callback = function(v) print(v) end
})
-- > Move o componente para o container da sub-aba
AbaGeral:AddComponent(toggleFarm)
```

---

## Componente: Label & Divider

```lua
-- > Label com suporte a imagens externas (com cache)
local MinhaLabel = MeuPainel:CreateLabel(MinhaAba, {
    Title = "Status do Servidor",
    Desc = "O servidor está operando normalmente.",
    Image = "http://sua-url.com/imagem.png", 
    imageGround = "medium", -- "min", "medium", "max"
    Color = Color3.fromRGB(255, 255, 255)
})

-- > Divisor visual com texto central
MeuPainel:CreateDivider(MinhaAba, {
    Text = "CONFIGURAÇÕES DE COMBATE",
    Height = 30
})
```

---

## Sistema de Notificações

```lua
-- > Notificação flutuante com suporte a localização
Tekscripts:Notify({
    Title = "loc:welcome",      -- > Chave de tradução
    Desc = "Sistema carregado com sucesso!", 
    Duration = 5,               
    Position = "Below",         -- "Above" ou "Below"
    Icon = "rbxassetid://0"     
})
```

> [!IMPORTANT]
> **Persistência e Bugs:** Sempre utilize o método `:Destroy()` ao remover abas ou componentes dinâmicos para evitar vazamentos de memória e garantir que as conexões de eventos do Roblox sejam encerradas.
