#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# install.packages(c("shiny", "tidyverse", "dplyr", "ggplot2", "DT", "arrow"))
library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(DT)       # Para tablas interactivas
library(arrow)    # Para la parte de "guardar" (aunque no se usa en la app)


# ===================================================================
# 1. CARGAR DATOS Y PROCESAMIENTO PREVIO
# (Esto se ejecuta UNA VEZ cuando la app inicia)
# ===================================================================

data <- read.csv("boston_housing.csv")


# Instalar paquetes si no los tienes
# install.packages(c("shiny", "tidyverse", "dplyr", "ggplot2", "DT", "arrow"))

library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(DT)       # Para tablas interactivas
library(arrow)    # Para la parte de "guardar" (aunque no se usa en la app)

# ===================================================================
# 1. CARGAR DATOS Y PROCESAMIENTO PREVIO
# (Esto se ejecuta UNA VEZ cuando la app inicia)
# ===================================================================

# Cargar datos
data <- read.csv("boston_housing.csv")

# Obtener nombres de variables numéricas para los selectores
numeric_vars <- data %>% select(where(is.numeric)) %>% names()
# Variables predictoras (todas menos MEDV)
predictor_vars <- setdiff(numeric_vars, "MEDV")

# --- Cálculos del RMarkdown (pre-calculamos lo que es estático) ---

# Tabla resumen univariada (copiada de tu script)
summary_table <- data %>%
  select(where(is.numeric)) %>%
  summarize(across(everything(), list(
    minimo = ~min(.x, na.rm = TRUE),
    maximo = ~max(.x, na.rm = TRUE),
    media = ~mean(.x, na.rm = TRUE),
    mediana = ~median(.x, na.rm = TRUE),
    sd = ~sd(.x, na.rm = TRUE),
    q25 = ~quantile(.x, probs = 0.25, na.rm = TRUE),
    q50 = ~quantile(.x, probs = 0.5, na.rm = TRUE),
    q75 = ~quantile(.x, probs = 0.75, na.rm = TRUE)
  ), .names = "{col}_{fn}")) %>%
  pivot_longer(everything(), names_to = c("variable", "estadistico"), names_sep = "_(?=[^_]+$)") %>%
  pivot_wider(names_from = estadistico, values_from = value) %>%
  relocate(variable)

# Datos para el gráfico facet_wrap (copiado de tu script)
vars <- c("CRIM","ZN","INDUS","NOX","RM","AGE","DIS","RAD","TAX","PTRATIO","B","LSTAT")

corr_df <- data %>%
  select(all_of(vars), MEDV) %>%
  summarise(across(all_of(vars), ~cor(.x, MEDV, use = "complete.obs"))) %>%
  pivot_longer(cols = everything(), names_to = "variable", values_to = "correlacion")

data_long <- data %>%
  pivot_longer(cols = all_of(vars),
               names_to = "variable",
               values_to = "valor") %>%
  left_join(corr_df, by = "variable")

# Gráfico estático (lo definimos como un objeto)
plot_facet_static <- ggplot(data_long, aes(x = valor, y = MEDV)) +
  geom_point(alpha = 0.5, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  facet_wrap(~ variable, scales = "free_x") +
  geom_text(
    data = corr_df,
    aes(x = -Inf, y = Inf, label = paste0("r = ", round(correlacion, 2))),
    hjust = -0.1, vjust = 1.2, size = 3,
    fill = "white", color = "black",
    inherit.aes = FALSE
  ) +
  labs(
    title = "Relación entre MEDV y variables predictoras (con correlaciones)",
    x = "Valor de la variable",
    y = "MEDV (valor medio de la vivienda)"
  ) +
  theme_minimal()


# ===================================================================
# 2. INTERFAZ DE USUARIO (UI)
# ===================================================================
ui <- fluidPage(
  
  # Título de la aplicación
  titlePanel("Análisis Exploratorio (EDA) - Boston Housing"),
  
  # Usar una barra de navegación para organizar por pestañas
  navbarPage("Análisis",
             
             # --- Pestaña 1: Datos ---
             tabPanel("Datos",
                      icon = icon("table"),
                      h3("Conjunto de Datos de Vivienda en Boston"),
                      p("Vista interactiva de los datos cargados."),
                      DT::dataTableOutput("tabla_datos")
             ),
             
             # --- Pestaña 2: Análisis Univariado ---
             tabPanel("Análisis Univariado",
                      icon = icon("chart-pie"),
                      h3("Resumen Estadístico de Variables Numéricas"),
                      p("Cálculos de mínimo, máximo, media, mediana, sd y cuartiles."),
                      DT::dataTableOutput("tabla_resumen")
             ),
             
             # --- Pestaña 3: Análisis Bivariado ---
             tabPanel("Análisis Bivariado (vs. MEDV)",
                      icon = icon("chart-line"),
                      
                      # Sub-panel para el gráfico interactivo
                      h3("Relación Interactiva contra MEDV"),
                      p("Selecciona una variable para ver su relacion  con MEDV."),
                      sidebarLayout(
                        sidebarPanel(
                          # Selector para el gráfico bivariado interactivo
                          selectInput("var_bivariada", 
                                      "Selecciona una variable:",
                                      choices = predictor_vars,
                                      selected = "LSTAT")
                        ),
                        mainPanel(
                          plotOutput("plot_bivariado_interactivo"),
                          verbatimTextOutput("corr_bivariada_texto")
                        )
                      ),
                      
                      hr(), # Línea horizontal separadora
                      
                      # Sub-panel para el gráfico estático (facet_wrap)
                      h3("Relación de Todas las Variables con MEDV"),
                      p("Este es el gráfico general que muestra todas las correlaciones."),
                      # Aumentamos el alto para que se vea bien
                      plotOutput("plot_facet_correlaciones", height = "600px")
             ),
             
             # --- Pestaña 4: Distribuciones ---
             tabPanel("Distribuciones",
                      icon = icon("chart-bar"),
                      h3("Exploración de Distribuciones de Variables"),
                      p("Selecciona una variable y el tipo de gráfico para explorar su distribución."),
                      sidebarLayout(
                        sidebarPanel(
                          # Selector de variable
                          selectInput("var_dist", 
                                      "Selecciona una variable:",
                                      choices = numeric_vars,
                                      selected = "MEDV"),
                          
                          # Selector de tipo de gráfico
                          radioButtons("tipo_plot", 
                                       "Selecciona el tipo de gráfico:",
                                       choices = c("Histograma", "Boxplot"),
                                       selected = "Histograma"),
                          
                          # Slider condicional (solo aparece si se elige Histograma)
                          conditionalPanel(
                            condition = "input.tipo_plot == 'Histograma'",
                            sliderInput("bins", 
                                        "Número de Bins (Histograma):",
                                        min = 5,
                                        max = 50,
                                        value = 25)
                          )
                        ),
                        mainPanel(
                          plotOutput("plot_distribucion")
                        )
                      )
             )
  )
)

# ===================================================================
# 3. SERVIDOR (Lógica de la Aplicación)
# ===================================================================
server <- function(input, output) {
  
  # --- Pestaña 1: Datos ---
  output$tabla_datos <- DT::renderDataTable({
    DT::datatable(data, 
                  options = list(pageLength = 10, scrollX = TRUE), 
                  rownames = FALSE)
  })
  
  # --- Pestaña 2: Análisis Univariado ---
  output$tabla_resumen <- DT::renderDataTable({
    DT::datatable(summary_table, 
                  options = list(pageLength = 15, scrollX = TRUE),
                  rownames = FALSE)
  })
  
  # --- Pestaña 3: Análisis Bivariado ---
  
  # Gráfico interactivo (reacciona a input$var_bivariada)
  output$plot_bivariado_interactivo <- renderPlot({
    # Usamos aes_string porque el nombre de la variable viene de un input
    ggplot(data, aes_string(x = input$var_bivariada, y = "MEDV")) +
      geom_point(color = "steelblue", alpha = 0.6) +
      geom_smooth(method = "lm", color = "red") +
      labs(
        title = paste("Relación entre", input$var_bivariada, "y MEDV"),
        x = input$var_bivariada,
        y = "MEDV (valor medio de la vivienda)"
      ) +
      theme_minimal(base_size = 15)
  })
  
  # Texto de correlación (reacciona a input$var_bivariada)
  output$corr_bivariada_texto <- renderPrint({
    corr_valor <- cor(data[[input$var_bivariada]], data$MEDV, use = "complete.obs")
    cat(paste0("Correlación (Pearson) entre ", input$var_bivariada, " y MEDV: ", round(corr_valor, 3)))
  })
  
  # Gráfico estático (simplemente renderiza el objeto que ya creamos)
  output$plot_facet_correlaciones <- renderPlot({
    plot_facet_static
  })
  
  # --- Pestaña 4: Distribuciones ---
  
  # Gráfico de distribución (reacciona a input$var_dist, input$tipo_plot, y input$bins)
  output$plot_distribucion <- renderPlot({
    
    # El usuario seleccionó Histograma
    if (input$tipo_plot == "Histograma") {
      ggplot(data, aes_string(x = input$var_dist)) +
        geom_histogram(bins = input$bins, fill = "lightblue", color = "black", alpha = 0.7) +
        labs(
          title = paste("Histograma de", input$var_dist),
          x = input$var_dist,
          y = "Frecuencia"
        ) +
        theme_minimal(base_size = 15)
      
      # El usuario seleccionó Boxplot
    } else {
      ggplot(data, aes_string(x = 1, y = input$var_dist)) + # Usamos x=1 para un solo boxplot
        geom_boxplot(fill = "lightgreen", color = "black", alpha = 0.7) +
        coord_flip() + # Lo hacemos horizontal como en tu Rmd
        labs(
          title = paste("Boxplot de", input$var_dist),
          y = input$var_dist
        ) +
        theme_minimal(base_size = 15) +
        theme(axis.text.y = element_blank(), # Escondemos el "1" del eje x
              axis.ticks.y = element_blank())
    }
  })
  
}

# ===================================================================
# 4. EJECUTAR LA APLICACIÓN
# ===================================================================
shinyApp(ui = ui, server = server)