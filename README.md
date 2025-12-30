# Tekscripts UIX: Documentação Oficial

Bem-vindo à documentação da Tekscripts UIX. Abaixo você encontrará todos os métodos para inicialização, configuração de sistema e criação de componentes.

---

## Inicialização: init
Insira este trecho no início do seu código para carregar os componentes necessários da biblioteca.

```lua
-- > Inicialização da UI
local Tekscripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/TekScripts/TekUix/refs/heads/main/src/main.lua"))()
```

---

## Sistema: Localization
O módulo Localization permite a tradução dinâmica. Deve ser configurado logo após a inicialização para que os componentes já nasçam com os textos corretos.

### Exemplo de Configuração
```lua
-- > Configurando dicionário de idiomas
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

-- > Definindo o idioma ativo
Tekscripts.Localization:SetLanguage("pt")
```

### API de Localização (Métodos)
| Método | Descrição |
| :--- | :--- |
| :Init(table) | Inicializa o sistema com a tabela de traduções. |
| :SetLanguage(lang) | Altera o idioma global (ex: "pt", "en"). |
| :Get(key) | Busca o valor traduzido de uma chave (ex: "loc:welcome"). |
| :SetEnabled(bool) | Ativa ou desativa o sistema de tradução. |

---

## Gerenciamento da Janela

### Tekscripts.new
Criação da janela principal (Window). Este é o container pai de todos os outros elementos.

```lua
-- > Criando a instância principal do painel
local MeuPainel = Tekscripts.new({
    Name = "Meu Painel",                 -- > String  | Título da interface
    FloatText = "Abrir",                 -- > String  | Texto do botão flutuante inicial
    startTab = "auto",                   -- > String  | Define qual aba abre primeiro
    iconId = "rbxassetid://105089076803454", -- > String  | Ícone da janela
    Transparent = true,                  -- > Boolean | Ativa transparência
    Transparency = 0.5,                  -- > Number  | Nível da transparência (0 a 1)
    LoadScreen = true,                   -- > Boolean | Exibe tela de carregamento
    Loading = { 
        Title = "TekScripts", 
        Desc = "Carregando módulos..."
    },                                   -- > Table   | Configurações do Loading
})
```

### Tekscripts:FloatButtonEdit
Permite editar o botão flutuante global que minimiza/abre a interface.

```lua
-- > Editando propriedades do botão de toggle da interface
Tekscripts:FloatButtonEdit({
    Text = "Menu", 
    Icon = "rbxassetid://123456" 
})
```

---

## Gerenciamento de Abas (Tabs)

### Tekscripts:CreateTab
Cria uma nova aba lateral.

```lua
-- > Criando uma nova aba na lateral
local MinhaAba = MeuPainel:CreateTab({
    Title = "Minha Aba" -- > String
})
```

---

## Componente: Toggle
Interruptor de estado booleano (On/Off).

```lua
-- > Criando um interruptor funcional
local meuToggle = MeuPainel:CreateToggle(MinhaAba, {
    Text = "Velocidade Máxima",
    Desc = "Aumenta a velocidade do personagem",
    Type = "Toggle", -- > "Toggle" ou "CheckBox"
    FeedbackDebug = true,
    Callback = function(state)
        print("Estado:", state)
    end
})

-- > Métodos API
meuToggle:SetState(true) -- > Altera o estado via script
meuToggle:SetLocked(true) -- > Tranca a função (ex: VIP)
```

---

## Componente: Slider
Seleção de valores numéricos dentro de um intervalo.

```lua
-- > Criando um seletor numérico
local MeuSlider = MeuPainel:CreateSlider(MinhaAba, {
    Text = "WalkSpeed",
    Min = 16,
    Max = 100,
    Step = 1,
    Value = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

-- > Métodos API
MeuSlider:Set(50) -- > Define valor manualmente
MeuSlider:SetRange(10, 200, 5) -- > Altera os limites dinamicamente
```

---

## Componente: Dropdown
Menu de seleção de itens (única ou múltipla).

```lua
-- > Criando menu de seleção
local MeuDropdown = MeuPainel:CreateDropdown(MinhaAba, {
    Title = "Escolha o Mapa",
    Values = {
        { Name = "Deserto", Image = "rbxassetid://1" },
        { Name = "Neve" }
    },
    MultiSelect = false,
    Callback = function(selected)
        print("Selecionado:", selected)
    end
})

-- > Métodos API
MeuDropdown:AddItem({Name = "Floresta"}) -- > Adiciona item novo
MeuDropdown:ClearItems() -- > Limpa a lista
```

---

## Componente: Input
Campo para entrada de texto ou números.

```lua
-- > Criando campo de entrada
local MeuInput = MeuPainel:CreateInput(MinhaAba, {
    Text = "Username",
    Placeholder = "Digite aqui...",
    Type = "string", -- > "string" ou "number"
    Callback = function(txt)
        print("Digitado:", txt)
    end
})

-- > Métodos API
MeuInput:SetBlocked(true, "🔒 Trancado") -- > Bloqueia o campo
```

---

## Componente: Bind
Vincula uma tecla do teclado a uma função.

```lua
-- > Criando atalho de teclado
local MeuBind = MeuPainel:CreateBind(MinhaAba, {
    Text = "Kill Aura",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Tecla pressionada!")
    end
})

-- > Métodos API
MeuBind:SetKey(Enum.KeyCode.G) -- > Altera a tecla via script
```

---

## Componente: Button
Botão padrão para execução de ações.

```lua
-- > Criando botão de clique
local MeuBotao = MeuPainel:CreateButton(MinhaAba, {
    Text = "Executar",
    Debounce = 0.5,
    Callback = function()
        print("Clicado!")
    end
})

-- > Métodos API
MeuBotao:SetBlocked(true) -- > Desativa o clique
```

---

## Componente: Section
Agrupador de componentes expansível.

```lua
-- > Criando grupo organizado
local MinhaSecao = MeuPainel:CreateSection(MinhaAba, {
    Title = "Combate",
    Open = true
})

-- > Adicionando itens à seção
MinhaSecao:AddComponent(meuToggle, MeuSlider)

-- > Métodos API
MinhaSecao:Block(true, "Bloqueado") -- > Bloqueia o grupo todo
```

---

## Componente: TabContainer
Sistema de sub-abas horizontais dentro de uma aba.

```lua
-- > Criando container de sub-abas
local SubSistema = MeuPainel:CreateTabContainer(MinhaAba, {
    Title = "Config Avançadas"
})

local AbaGeral = SubSistema:AddTab("Geral")
AbaGeral:AddComponent(MeuBotao) -- > Move o botão para a sub-aba
```

---

## Componente: TextBox
Área de texto multi-linha (ideal para logs).

```lua
-- > Criando console de log
local logBox = MeuPainel:CreateTextBox(MinhaAba, {
    Text = "Logs",
    ReadOnly = true
})

-- > Métodos API
logBox:Append("Nova linha de log") -- > Adiciona texto ao final
logBox:Clear() -- > Limpa tudo
```

---

## Componente: Dialog
Janela modal centralizada para avisos ou confirmações.

```lua
-- > Criando alerta crítico
MeuPainel:CreateDialog({
    Title = "Aviso",
    Message = "Deseja continuar?",
    Buttons = {
        { Text = "Não" },
        { Text = "Sim", Callback = function() print("Sim!") end }
    }
})
```

---

## Componente: FloatButton (Independente)
Botão flutuante extra que fica solto na tela.

```lua
-- > Criando botão flutuante de atalho
local MeuFloat = MeuPainel:CreateFloatButton({
    Text = "Quick Action",
    Drag = true,
    Callback = function() print("Ação rápida!") end
})
```

---

## Componente: Label & Divider
Elementos visuais de organização.

```lua
-- > Criando rótulo informativo
MeuPainel:CreateLabel(MinhaAba, {
    Title = "Aviso",
    Desc = "Texto de suporte aqui",
    Image = "rbxassetid://0",
    imageGround = "medium"
})

-- > Criando divisor de linha
MeuPainel:CreateDivider(MinhaAba, {
    Text = "SEÇÃO DE CONFIGURAÇÃO",
    Height = 30
})
```

---

## Sistema de Notificações: Notify
Notificações temporárias que aparecem no canto da tela.

```lua
-- > Exibindo notificação ao usuário
Tekscripts:Notify({
    Title = "Sucesso",
    Desc = "Configuração aplicada!",
    Duration = 5,
    Position = "Below" -- > "Above" ou "Below"
})
```
