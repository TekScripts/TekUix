# Tekscripts UIX: Documentação Oficial

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
Tekscripts:FloatButtonEdit({
    Text = "Abrir Menu", -- > String | Nome que aparece no FloatButton
    Icon = "menu"        -- > String | Ícone exibido ao lado esquerdo
})
```

### Tekscripts.new
Criação da janela principal (Window). Essencial para hospedar todos os outros componentes.

```lua
local MeuPainel = Tekscripts.new({
    Name = painel               -- > String  | Título do painel
    FloatText = "Abrir Painel",          -- > String  | Texto do botão flutuante
    startTab = "auto",                   -- > String  | Tab selecionada inicialmente
    iconId = "rbxassetid://105089076803454", -- > String  | ID do ícone da interface
    Transparent = true,                  -- > Boolean | Define se o painel é transpartransparenflutuantesparency = 0.5,            -- > Number  | Nível de transparência (0 a 1)
    LoadScreen = true,                   -- > Boolean | Ativa sistema de carregamento
    Loading = { 
        Title = "TekScripts", 
        Desc = "By: Kauam"
    },                                   -- > Array   | Configuração da tela de load
})
```

---

## Gerenciamento de Abas (Tabs)

### Tekscripts:CreateTab
Cria uma nova seção lateral na interface.

```lua
local MinhaAba = MeuPainel:CreateTab({
    Title = "Minha Aba" -- > String
})
```

#### Métodos da Aba
* **Destruir Aba:** `MinhaAba:Destroy()` (Remove a aba e limpa conexões).
* **Alternar Aba:** `Tekscripts:SetActiveTab(MinhaAba)` (Força a visualização via script).

---

## Componente: Toggle

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Nome principal exibido no Toggle. |
| Desc | string? | Descrição detalhada abaixo do título (opcional). |
| Callback | function | Função executada ao alternar (state: boolean). |
| Type | string? | Estilo visual: "Toggle" (Padrão) ou "CheckBox". |
| FeedbackDebug| boolean?| Se true, exibe tremor e borda vermelha em erros. |

### Exemplo de Uso
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

-- Definir estado manualmente
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

> [!IMPORTANT]
> **Locked vs Blocked:** Use SetLocked para travar itens que o usuário não comprou. Use SetBlocked para evitar que o usuário clique repetidamente enquanto uma função pesada está processando.

---

## Componente: Slider

### Exemplo de Criação
```lua
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
```

### API do Slider
| Método | Descrição |
| :--- | :--- |
| :Get() | Retorna o valor atual do Slider. |
| :Set(val) | Define um novo valor para o Slider. |
| :GetPercent() | Retorna o percentual (0 a 1). |
| :SetRange(min, max, step) | Altera os limites dinamicamente. |
| :AnimateTo(val, time) | Move o slider suavemente até um valor. |
| :OnChanged(fn) | Escuta mudanças sem alterar o Callback inicial. |
| :Update(table) | Atualiza propriedades como Texto e Valor de uma vez. |

---

## Componente: TextBox (Log/Input)

### Exemplo de Criação
```lua
local logBox = MeuPainel:CreateTextBox(MinhaAba, {
    Text = "Console de Logs",
    Desc = "Histórico de eventos",
    Default = "Iniciando sistema...\n",
    ReadOnly = true -- Se true, o usuário não pode digitar dentro.
})
```

### API do TextBox
| Método | Descrição |
| :--- | :--- |
| :SetText(string) | Substitui todo o conteúdo do box. |
| :GetText() | Retorna o texto atual. |
| :Append(string) | Adiciona uma nova linha/texto ao final do log. |
| :Clear() | Limpa todo o conteúdo do box. |
| :Destroy() | Remove o componente. |

## Componente: Bind

O componente CreateBind permite que o usuário vincule uma tecla (Keycode) a uma função específica.

### Exemplo de Criação
```lua
local MeuBind = MeuPainel:CreateBind(MinhaAba, {
    Text = "Ativar Kill Aura",
    Desc = "Pressione a tecla para alternar o estado",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Bind pressionado! Tecla: " .. key.Name)
    end
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Nome principal exibido no componente. |
| Desc | string? | Descrição detalhada abaixo do título (opcional). |
| Default | EnumItem | Tecla padrão inicial (ex: Enum.KeyCode.F). |
| Callback | function | Função executada sempre que a tecla for pressionada. |

### API do Bind (Métodos)

| Método | Descrição |
| :--- | :--- |
| :GetKey() | Retorna o Enum.KeyCode da tecla atualmente vinculada. |
| :SetKey(Enum.KeyCode) | Define manualmente uma nova tecla para o bind. |
| :Listen() | Força o componente a entrar no modo de escuta (esperando uma tecla). |
| :Update(table) | Atualiza o texto, descrição ou tecla padrão dinamicamente. |
| :Destroy() | Remove o componente e limpa todas as conexões de entrada. |

### Exemplo de Uso Real
```lua
local flightBind = MeuPainel:CreateBind(MinhaAba, {
    Text = "Voar",
    Desc = "Tecla para ligar/desligar o vôo",
    Default = Enum.KeyCode.X,
    Callback = function()
        -- Sua lógica de vôo aqui
        print("Alternando estado de vôo")
    end
})

-- Alterando a tecla via script após 10 segundos
task.wait(10)
flightBind:SetKey(Enum.KeyCode.Z)
```

> [!IMPORTANT]
> O componente possui tratamento de erro interno. Caso o callback falhe, o botão de bind piscará em vermelho para indicar que a execução não foi concluída com sucesso.

## Componente: Dropdown

O componente CreateDropdown oferece uma lista de seleção única ou múltipla, com suporte a imagens e atualização dinâmica de itens.

### Exemplo de Criação
```lua
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
        print("Selecionado:", selected)
    end
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Title | string | Título exibido no cabeçalho do dropdown. |
| Values | table | Lista de tabelas contendo { Name: string, Image: string? }. |
| MultiSelect | boolean? | Se true, permite selecionar múltiplos itens simultaneamente. |
| MaxVisibleItems | number? | Limite de itens visíveis antes de habilitar a rolagem (Máx: 8). |
| InitialValues | table? | Lista de strings com os nomes dos itens selecionados ao iniciar. |
| Callback | function | Retorna uma string (seleção única) ou table (múltipla). |

### API do Dropdown (Métodos)

| Método | Descrição |
| :--- | :--- |
| :GetSelected() | Retorna o valor atual (string ou table). |
| :SetSelected(values) | Define a seleção via script (aceita string ou table). |
| :AddItem(valueInfo, pos) | Adiciona um novo item dinamicamente em uma posição específica. |
| :RemoveItem(name) | Remove um item da lista pelo nome. |
| :ClearItems() | Remove todos os itens da lista de uma vez. |
| :Toggle() | Abre ou fecha o menu de opções. |
| :Close() | Fecha o menu caso ele esteja aberto. |
| :Destroy() | Remove o componente apagando completamente |

### Exemplo de Uso Múltiplo
```lua
local modDropdown = MeuPainel:CreateDropdown(MinhaAba, {
    Title = "Modificadores",
    Values = {
        { Name = "Pulo Infinito" },
        { Name = "Velocidade" },
        { Name = "Noclip" }
    },
    MultiSelect = true,
    Callback = function(list)
        for _, power in ipairs(list) do
            print("Poder ativo: " .. power)
        end
    end
})
```

> [!IMPORTANT]
> O Dropdown possui ajuste automático de altura (AutomaticSize). No entanto, o limite de altura total é respeitado com base no MaxVisibleItems para não poluir a interface.

## Componente: Dialog

O componente CreateDialog cria uma janela de alerta ou confirmação centralizada que sobrepõe toda a interface (modal), bloqueando a interação com o fundo até que uma ação seja tomada.

### Exemplo de Criação
```lua
local MeuDialog = MeuPainel:CreateDialog({
    Title = "Aviso do Sistema",
    Message = "Você tem certeza que deseja resetar suas configurações?",
    Buttons = {
        {
            Text = "Cancelar",
            Callback = function()
                print("Ação cancelada")
            end
        },
        {
            Text = "Confirmar",
            Callback = function()
                print("Ação confirmada")
            end
        }
    }
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Title | string | Título principal exibido no topo do diálogo. |
| Message | string | Texto informativo ou pergunta central da janela. |
| Buttons | table | Lista de tabelas contendo { Text: string, Callback: function }. |

### API do Dialog (Métodos)

| Método | Descrição |
| :--- | :--- |
| :Destroy() | Fecha o diálogo e limpa todas as conexões. |

### Exemplo de Alerta Simples
```lua
MeuPainel:CreateDialog({
    Title = "Erro de Conexão",
    Message = "Não foi possível carregar os dados do servidor.",
    Buttons = {
        { Text = "Ok" } -- Callback vazio apenas fecha a janela
    }
})
```

> [!IMPORTANT]
> Diferente de outros componentes, o CreateDialog não requer um objeto "tab" como primeiro argumento, pois ele é criado diretamente no PlayerGui do usuário.

## Componente: Input

O componente CreateInput permite a entrada de texto ou números pelo usuário, com suporte a placeholders, descrições e sistema de bloqueio visual.

### Exemplo de Criação
```lua
local MeuInput = MeuPainel:CreateInput(MinhaAba, {
    Text = "Nome do Item",
    Placeholder = "Digite aqui...",
    Desc = "Este nome será exibido no inventário",
    Type = "string", -- Ou "number"
    Callback = function(txt)
        print("Texto digitado: " .. txt)
    end
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Título principal exibido acima ou ao lado do campo. |
| Placeholder | string? | Texto de sugestão que aparece quando o campo está vazio. |
| Desc | string? | Pequena descrição explicativa abaixo do campo. |
| Type | string? | Define o filtro: "string" (padrão) ou "number" (aceita apenas números). |
| BlockText | string? | Texto exibido quando o componente está bloqueado (Ex: "🔒 TRANCADO"). |
| Callback | function | Função executada ao pressionar Enter ou ao mudar o valor (se for número). |

### API do Input (Métodos)

| Método | Descrição |
| :--- | :--- |
| :SetBlocked(bool, text) | Ativa ou desativa o bloqueio do campo com um overlay visual e texto customizado. |
| :Update(table) | Atualiza o título, placeholder, descrição ou valor do campo dinamicamente. |
| :Destroy() | Remove o componente, desconecta eventos de hover e limpa a memória. |

### Exemplo de Input Numérico com Bloqueio
```lua
local ageInput = MeuPainel:CreateInput(MinhaAba, {
    Text = "Idade",
    Placeholder = "0",
    Type = "number",
    Callback = function(val)
        print("Idade definida para: " .. val)
    end
})

-- Bloqueia o input após 5 segundos
task.delay(5, function()
    ageInput:SetBlocked(true, "BLOQUEADO PELO SISTEMA")
end)
```

> [!IMPORTANT]
> No modo "string", o callback só é disparado quando o usuário perde o foco do campo (pressionando Enter ou clicando fora). No modo "number", o callback é disparado a cada alteração de caractere.

## Componente: Button

O componente CreateButton cria um botão interativo padrão com suporte a animações de clique, controle de debounce (cooldown) e feedback visual de erros.

### Exemplo de Criação
```lua
local MeuBotao = MeuPainel:CreateButton(MinhaAba, {
    Text = "Executar Script",
    Debounce = 0.5, -- Intervalo mínimo entre cliques em segundos
    Callback = function()
        print("Botão acionado!")
    end
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Texto exibido no centro do botão. |
| Debounce | number? | Tempo de espera entre cliques (Padrão: 0.25s). |
| Callback | function | Função executada ao clicar no botão. |

### API do Botão (Métodos)

| Método | Descrição |
| :--- | :--- |
| :SetBlocked(bool) | Ativa ou desativa a interatividade do botão e altera sua cor visualmente. |
| :Update(table) | Atualiza o texto, o callback ou o tempo de debounce dinamicamente. |
| :Destroy() | Remove o componente da interface e limpa as conexões de eventos. |


### Exemplo de Fluxo com Bloqueio
```lua
local btnAcao = MeuPainel:CreateButton(MinhaAba, {
    Text = "Iniciar Processo",
    Callback = function()
        print("Processando...")
    end
})

-- Bloqueia o botão temporariamente
btnAcao:SetBlocked(true)

task.delay(5, function()
    btnAcao:SetBlocked(false)
    btnAcao:Update({Text = "Processo Finalizado"})
end)
```

> [!IMPORTANT]
> O CreateButton gerencia automaticamente a limpeza de memória através do método `:Destroy()`, desconectando eventos de MouseEnter, MouseLeave e Click para evitar vazamentos (memory leaks).

## Componente: FloatButton

O componente CreateFloatButton cria um botão flutuante independente que permanece na tela, permitindo execução de funções rápidas. Ele possui suporte nativo para arrasto (drag) tanto em dispositivos Desktop quanto Mobile.

### Exemplo de Criação
```lua
local MeuFloat = MeuPainel:CreateFloatButton({
    Text = "Executar",
    Title = "Mover Botão",
    Drag = true,
    Visible = true,
    Pos = UDim2.new(0.1, 0, 0.5, 0),
    Callback = function()
        print("Botão flutuante acionado!")
    end
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Text | string | Texto principal exibido no corpo do botão. |
| Title | string? | Texto exibido no cabeçalho de arrasto (se Drag for true). |
| Drag | boolean? | Define se o botão terá um cabeçalho para ser movido (Padrão: true). |
| Visible | boolean? | Define a visibilidade inicial do botão (Padrão: true). |
| Pos | UDim2? | Posição inicial do botão na tela. |
| Callback | function | Função executada ao clicar no botão. |

### API do FloatButton (Métodos)

| Método | Descrição |
| :--- | :--- |
| :SetText(string) | Altera o texto do botão principal. |
| :SetTitle(string) | Altera o texto do cabeçalho de arrasto. |
| :SetVisible(bool) | Alterna a visibilidade do componente na tela. |
| :SetBlock(bool) | Ativa ou desativa um overlay que impede a interação com o botão. |
| :Destroy() | Remove o botão e limpa todos os recursos e GUIs associadas. |

### Exemplo com Bloqueio e Atualização
```lua
local floatBtn = MeuPainel:CreateFloatButton({
    Text = "Aguarde...",
    Drag = true,
    Callback = function()
        print("Clicou!")
    end
})

-- Bloqueia a interação e altera o texto
floatBtn:SetBlock(true)
floatBtn:SetTitle("Bloqueado")

task.delay(5, function()
    floatBtn:SetBlock(false)
    floatBtn:SetText("Liberado")
    floatBtn:SetTitle("Arraste aqui")
end)
```

> [!IMPORTANT]
> Se a opção `Drag` for desativada, o cabeçalho superior é removido e o botão reduz de tamanho automaticamente, mantendo apenas a área clicável.

## Sistema: Localization

O módulo Localization permite a tradução dinâmica de textos dentro da interface, facilitando o suporte a múltiplos idiomas através de chaves de tradução.

### Exemplo de Configuração
```lua
-- Configurando traduções iniciais
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

-- Definindo o idioma atual
Tekscripts.Localization:SetLanguage("pt")
```

### Propriedades de Configuração

| Propriedade | Tipo | Descrição |
| :--- | :--- | :--- |
| Enabled | boolean | Define se o sistema de tradução está ativo. |
| Prefix | string | Prefixo identificador para chaves (Padrão: "loc:"). |
| DefaultLanguage | string | Idioma de reserva caso a tradução falhe. |

### API de Localização (Métodos)

| Método | Descrição |
| :--- | :--- |
| :Init(table) | Inicializa o sistema com uma tabela completa de traduções. |
| :SetLanguage(lang) | Altera o idioma global do sistema. |
| :GetLanguage() | Retorna o código do idioma selecionado no momento. |
| :SetTranslations(lang, table) | Adiciona ou atualiza traduções para um idioma específico. |
| :Get(key) | Busca o valor traduzido de uma chave (ex: "loc:welcome"). |
| :SetEnabled(bool) | Ativa ou desativa o sistema dinamicamente. |

### Exemplo de Uso Prático
```lua
-- Criando um componente usando chaves de tradução
local meuToggle = MeuPainel:CreateToggle(MinhaAba, {
    Text = "loc:speed", -- Será traduzido para "Velocidade de Caminhada" (em PT)
    Callback = function(v)
        print("Toggle alterado")
    end
})

-- Alterando idioma em tempo real
task.wait(5)
MeuPainel.Localization:SetLanguage("en")
-- O próximo Get("loc:speed") retornará "Walk Speed"
```

> [!IMPORTANT]
> O sistema de localização deve ser inicializado antes da criação dos componentes para que os textos sejam aplicados corretamente durante o carregamento da interface.
se possível abaixo da inicialização.

## Componente: Section

O componente CreateSection permite agrupar múltiplos componentes em uma categoria expansível e colapsável, ideal para organizar interfaces com muitas funcionalidades.

### Exemplo de Criação
```lua
local MinhaSecao = MeuPainel:CreateSection(MinhaAba, {
    Title = "Configurações de Combate",
    Open = true,   -- Define se inicia aberta
    Fixed = false  -- Se true, impede o usuário de fechar a seção
})

-- Adicionando componentes à seção
MinhaSecao:AddComponent(meuToggle, meuSlider, meuButton)
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Title | string? | Texto exibido no cabeçalho da seção. |
| Open | boolean? | Define o estado inicial da seção (Padrão: true). |
| Fixed | boolean? | Se true, oculta a seta e impede o fechamento manual (Padrão: false). |

### API da Section (Métodos)

| Método | Descrição |
| :--- | :--- |
| :AddComponent(...) | Adiciona um ou mais componentes criados anteriormente à seção. |
| :SetTitle(string) | Altera o título da seção dinamicamente. |
| :Open() | Abre a seção via script. |
| :Close() | Fecha a seção via script. |
| :Toggle() | Alterna entre aberto e fechado. |
| :Block(bool, msg) | Ativa um overlay de bloqueio com mensagem personalizada sobre o conteúdo. |
| :Destroy() | Remove a seção e todos os componentes contidos nela. |

### Exemplo de Uso Avançado
```lua
local section = MeuPainel:CreateSection(MinhaAba, {
    Title = "Área Restrita",
    Open = false
})

-- Bloqueia a seção inicialmente
section:Block(true, "Necessário Nível 10")

-- Exemplo de desbloqueio dinâmico
task.delay(10, function()
    section:Block(false)
    section:Open()
    section:SetTitle("Área Liberada")
end)
```

> [!IMPORTANT]
> Ao chamar o método `:Destroy()` em uma seção, a Tekscripts irá automaticamente chamar o método `:Destroy()` de cada componente que foi adicionado a ela via `AddComponent`, garantindo uma limpeza completa da memória.

## Componente: TabContainer

O componente CreateTabContainer permite criar um sistema de sub-abas (Tab View) dentro de uma aba principal. É ideal para organizar grandes quantidades de conteúdo em categorias horizontais sem poluir a barra lateral principal.

### Exemplo de Criação
```lua
-- 1. Cria o container dentro de uma aba existente
local SubSistema = MeuPainel:CreateTabContainer(MinhaAba, {
    Title = "Configurações Avançadas",
    TabBarHeight = 45
})

-- 2. Adiciona sub-abas ao container
local AbaGeral = SubSistema:AddTab("Geral")
local AbaSeguranca = SubSistema:AddTab("Segurança")

-- 3. Adiciona componentes às sub-abas
local meuToggle = MeuPainel:CreateToggle(AbaGeral, {
    Text = "Auto Farm",
    Callback = function(v) print(v) end
})
-- Importante: Use o método AddComponent para mover o componente para a sub-aba
AbaGeral:AddComponent(meuToggle)
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Title | string? | Título identificador do container (opcional). |
| TabBarHeight | number? | Altura da barra superior onde ficam os botões das abas (Padrão: 40). |

---

### API do TabContainer (Métodos do Container)

| Método | Descrição |
| :--- | :--- |
| :AddTab(name) | Cria uma nova sub-aba e retorna sua API. |
| :SwitchTo(name) | Força a troca visual para a aba especificada pelo nome. |

### API da Sub-Aba (Métodos da Tab)

| Método | Descrição |
| :--- | :--- |
| :AddComponent(comp) | Move um ou mais componentes criados para dentro desta sub-aba. |

### Dica de Organização
Ao criar componentes para um `TabContainer`, você deve criá-los normalmente passando a sub-aba como `tab`, e em seguida chamar o método `:AddComponent()`. Isso garante que a hierarquia do Roblox seja atualizada corretamente para que o componente apareça dentro da `ScrollingFrame` da sub-aba e não na aba principal.

> [!IMPORTANT]
> A primeira aba adicionada via `:AddTab()` será automaticamente definida como a aba ativa por padrão.

## Componente: Label

O componente CreateLabel é utilizado para exibir informações, textos de suporte ou avisos, permitindo o uso de ícones locais ou externos com redimensionamento automático.

### Exemplo de Criação
```lua
local MinhaLabel = MeuPainel:CreateLabel(MinhaAba, {
    Title = "Status do Servidor",
    Desc = "O servidor está operando normalmente com 15 players.",
    Image = "[http://sua-url.com/imagem.png](http://sua-url.com/imagem.png)", -- Aceita URL ou ID do Roblox
    imageGround = "medium", -- "min", "medium" ou "max"
    Color = Color3.fromRGB(255, 255, 255)
})
```

### Estrutura do Parâmetro options

| Parâmetro | Tipo | Descrição |
| :--- | :--- | :--- |
| Title | string | Texto principal do Label. |
| Desc | string? | Subtexto descritivo exibido abaixo do título. |
| Image | string? | URL externa ou rbxassetid para o ícone lateral. |
| imageGround| string? | Define o tamanho do ícone: "min" (40px), "medium" (55px) ou "max" (75px). |
| Color | Color3? | Cor customizada para o título (ignora o tema se definido). |

### API do Label (Métodos)

| Método | Descrição |
| :--- | :--- |
| :SetText(string) | Atualiza o título do Label em tempo real. |
| :SetDescription(string) | Altera ou adiciona uma descrição ao componente. |
| :SetImage(url/id) | Carrega uma nova imagem (suporta cache automático de arquivos externos). |
| :SetVisible(bool) | Alterna a visibilidade do componente. |

---

## Componente: CreateDivider

O componente CreateDivider cria um separador visual com título centralizado, ideal para organizar diferentes seções dentro de uma aba.

### Exemplo de Criação
```lua
MeuPainel:CreateDivider(MinhaAba, {
    Text = "CONFIGURAÇÕES DE COMBATE",
    Color = Color3.fromRGB(40, 40, 45),
    Height = 30
})
```

### Parâmetros e API

* **Text:** Texto exibido no centro do divisor.
* **Height:** Altura vertical do box do divisor.
* **Color / TextColor:** Permite sobrescrever as cores de fundo e texto do tema.
* **:SetText(string):** Atualiza o título do divisor dinamicamente.

---


> [!IMPORTANT]
> O CreateLabel possui um sistema de cache para imagens externas. Uma vez que uma URL é carregada, a imagem é salva localmente para garantir carregamentos instantâneos em execuções futuras.
