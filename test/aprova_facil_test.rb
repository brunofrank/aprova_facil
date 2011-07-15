require 'test_helper'

class AprovaFacilTest < TestHelper

  def setup
    @aprova_facil = AprovaFacil.new
    @cartao = AprovaFacil::CartaoCredito.new(
      :valor => 25.00, 
      :numero_cartao => '4073020000000002', 
      :codigo_seguranca => '123', 
      :mes_validade => '10', 
      :ano_validade => '14', 
      :ip_comprador => '192.168.1.1', 
      :nome_portador => 'Bruno Frank Silva'
    )    
  end
  
  def test_comprar
    resultado = @aprova_facil.comprar @cartao
    
    assert_equal true, resultado[:aprovada] 
    assert_not_nil resultado[:resultado]     
    assert_not_nil resultado[:codigo_autorizacao]         
    assert_not_nil resultado[:transacao]             
    assert_equal '407302******0002', resultado[:cartao_mascarado] 
  end
  
  def test_comprar_cartao_invalido
    cartao_invalido = @cartao.dup
    cartao_invalido.codigo_seguranca = '502'
    resultado = @aprova_facil.comprar cartao_invalido
    
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
end
