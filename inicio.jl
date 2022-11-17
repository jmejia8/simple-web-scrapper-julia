# activa el entorno
# Se sugiere comentar en caso de usar la consola de Julia
import Pkg; Pkg.activate(".")

# importa bibliotecas necesarias
using HTTP, Gumbo, Cascadia, WordCloud


#=
function obtener_elemento(contenendor)

    d = Dict()
    for elemento in AbstractTrees.children(contenedor)
        d[tag(elemento)] = obtener_elemento(elemento)
    end

end
=#


function main()
    mi_url = "https://www.uv.mx/prensa/banner/uv-inauguro-xi-foro-internacional-de-estadistica-aplicada/"
    @info "Intentando descargar la página $mi_url"
    # descargar página
    r = HTTP.get(mi_url, status_exception=false)

    if r.status != 200
        println("Revisar que URL esté correcta o tenga acceso a internet")
        return
    end
    @info "Descargada correctamente"
    
    # Interpretanto los párrafos
    h = parsehtml(String(r.body))

    # selecciona la etiqueta
    selector = "p"

    @info "Extrayendo texto..."
    # haciendo la cosulta según el selector
    qs = eachmatch(Selector(selector),h.root)

    texto_obtenido = ""
    # por cada resultado de la consulta
    for q in qs
        texto_obtenido *= nodeText(q)
    end


    @info  "Texto obtenido:"
    println("--------------------------------------")
    println(texto_obtenido)
    println("--------------------------------------")

    # convierte en minúsculas
    texto_obtenido = lowercase(texto_obtenido)

    palabras_ignoradas = [ "la" , "el", "de", "que", "por", "en", "los" , "las"] .* " " .=> ""

    # elimina artículos (el, la, ...)
    texto_obtenido = replace(texto_obtenido, palabras_ignoradas...)

    @info "Generado Nube de palabras..."
    nube_palabras = generate!(wordcloud(texto_obtenido, fonts = ("Arial"), backgroundcolor="white"))
    paint(nube_palabras, "wordcloud.svg")



end

main()
