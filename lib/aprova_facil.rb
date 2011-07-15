require "net/https"
require "uri"
require 'aprova_facil/cartao_credito'
require 'aprova_facil/aprova_facil'
require "rexml/document"
$, = '-' # mudando o separador padrão

class AprovaFacil
  class Config
    def self.usuario
      @usuario
    end
  
    def self.usuario=(usuario)
      @usuario = usuario
    end  
  
    def self.teste?
      @test || false
    end
  
    def self.teste=(test)
      @test = test
    end  
  end
end