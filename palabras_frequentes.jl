using Gadfly, DataFrames, CSV, WordCloud

function filtra_palabras(texto_obtenido)
    texto_obtenido = lowercase(texto_obtenido)
    palabras_ignoradas = [ "la", " se", " un", " con", " su", " para", " una", " como", " sus", " lo" , "el", "de", "que", "por", " al", "en", "los" , "las", " es", " no", " más"] .* " " .=> ""
    # elimina artículos (el, la, ...)
    return replace(texto_obtenido, palabras_ignoradas...) |> uppercase
end


function crea_grafico_frecuencias(texto, max_palabras = 10)

    # pre-procesa texto
    texto = filtra_palabras(texto)

    # diccionario con frecuencias
    conteo_palabras = countwords(texto)
    # extrae palabras
    palabras = collect(keys(conteo_palabras))
    # extrae frecuencia
    frecuencia = [conteo_palabras[palabra] for palabra in palabras]

    # genera dataframe
    df = DataFrame(:Palabras => palabras, :Frecuencia =>  frecuencia)
    # ordena de manera descendiente respecto a la frecuencia
    sort!(df, :Frecuencia)

    # Gráfica de barra
    p = plot(
             last(df, max_palabras),
             x = :Frecuencia,
             y = :Palabras,
             Geom.bar(orientation=:horizontal),
             Theme(bar_spacing=3mm)
            )
    draw(SVG("frecuencia.svg"),p)

end

