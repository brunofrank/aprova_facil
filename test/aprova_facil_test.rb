require 'test_helper'
require 'digest/sha1'
      
class AprovaFacilTest < TestHelper

  def setup
    @aprova_facil = AprovaFacil.new
  end
  
  def test_aprovar
    resultado = nil
    3.times.each do 
      resultado = @aprova_facil.aprovar cartao      
      break if resultado[:aprovada]       
    end
    
    assert_equal true, resultado[:aprovada] 
    assert_not_nil resultado[:resultado]     
    assert_not_nil resultado[:codigo_autorizacao]         
    assert_not_nil resultado[:transacao]             
    assert_equal @cartao_mascarado, resultado[:cartao_mascarado] 
  end
  
  def test_aprovar_cartao_invalido
    cartao_invalido = cartao('502')
    resultado = nil
    3.times.each do     
      resultado = @aprova_facil.aprovar cartao_invalido
      break if !resultado[:aprovada]      
    end

    assert_equal false, resultado[:aprovada]
  end
  
  def test_recobrar
    resultado = nil
    3.times.each do 
      resultado = @aprova_facil.aprovar cartao      
      break if resultado[:aprovada]
    end
    assert_equal true, resultado[:aprovada]     
    
    resultado = @aprova_facil.capturar resultado[:transacao]
    assert_equal true, resultado[:capturado]                    
    
    3.times.each do 
      resultado = @aprova_facil.recobrar resultado[:transacao], 25.00
      break if resultado[:aprovada]
    end

    assert_equal true, resultado[:aprovada] 
  end
  
  def test_recobrar_transacao_invalida
    resultado = @aprova_facil.recobrar '123123', 25.00
    
    assert_equal false, resultado[:aprovada] 
  end  
  
  def test_capturar
    resultado = @aprova_facil.capturar '123123123123'
    
    assert_equal true, resultado[:capturado]                
  end
  
  def test_cancelar
    resultado = @aprova_facil.cancelar '123123123123'
    
    assert_equal true, resultado[:cancelado]
  end
  
  def test_get_url
    metodo = AprovaFacil::COMPRAR
    expected_url = AprovaFacil::URL_TEST.clone
    expected_url << AprovaFacil::Config.usuario + '/'

    url = @aprova_facil.send(:url, metodo)
    assert_equal url, expected_url + metodo
    
    metodo = AprovaFacil::CAPTURAR
    url = @aprova_facil.send(:url, metodo)    
    assert_equal url, expected_url + metodo
        
    metodo = AprovaFacil::CANCELAR
    url = @aprova_facil.send(:url, metodo)    
    assert_equal url, expected_url + metodo
  end
  
  private
    def cartao(codigo_seguranca = '123')
      numero_cartao = '4073020000000002'
      @cartao_mascarado = mascara_cartao(numero_cartao.clone)
      AprovaFacil::CartaoCredito.new(
       :valor => 25.00, 
       :numero_cartao => numero_cartao, 
       :codigo_seguranca => codigo_seguranca, 
       :mes_validade => '10', 
       :ano_validade => '14', 
       :ip_comprador => '192.168.1.1', 
       :nome_portador => 'Bruno Frank Silva Cordeiro'
      )
    end
    
    def mascara_cartao(cartao)
      cartao[6] = '*'
      cartao[7] = '*'
      cartao[8] = '*'
      cartao[9] = '*'
      cartao[10] = '*'
      cartao[11] = '*'                   
      cartao      
    end
end
