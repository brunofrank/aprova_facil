require 'test_helper'

class CartaoCreditoTest < TestHelper
  
  def setup
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
  
  def test_order_create
    assert_not_nil @cartao
  end
  
  def test_validations
    assert @cartao.valid?
  end
  
  def test_validation_valor
    cartao = @cartao.clone
    
    cartao.valor = '0'
    assert_equal false, cartao.valid?    

    cartao.valor = nil
    assert_equal false, cartao.valid?    

    cartao.valor = 25.00
    assert cartao.valid?        
  end

  def test_validation_parcelas      
    cartao = @cartao.clone
        
    cartao.parcelas = nil
    assert_equal false, cartao.valid?        
        
    cartao.parcelas = 0
    assert_equal false, cartao.valid?    

    cartao.parcelas = 1
    assert cartao.valid?        
  end
  
  def test_validation_numero_cartao            
    cartao = @cartao.clone
        
    cartao.numero_cartao = nil
    assert_equal false, cartao.valid?    
        
    # Numero Cartão em branco
    cartao.numero_cartao = ''
    assert_equal false, cartao.valid?    
    
    cartao.numero_cartao = '4073020000000002'
    assert cartao.valid?        
  end
  
  def test_validation_mes_validade     
    cartao = @cartao.clone
           
    cartao.mes_validade = nil
    assert_equal false, cartao.valid?
    
    cartao.mes_validade = '1'
    assert_equal false, cartao.valid?
    
    cartao.mes_validade = '123'
    assert_equal false, cartao.valid?
    
    cartao.mes_validade = 'aa'
    assert_equal false, cartao.valid?    
    
    cartao.mes_validade = '01'
    assert cartao.valid?
    
    cartao.mes_validade = '05'
    assert cartao.valid?
    
    cartao.mes_validade = '07'
    assert cartao.valid?
    
    cartao.mes_validade = '08'
    assert cartao.valid?
    
    cartao.mes_validade = '09'
    assert cartao.valid?
    
    cartao.mes_validade = '10'
    assert cartao.valid?
    
    cartao.mes_validade = '11'
    assert cartao.valid?
  end
    
  def test_validation_ano_validade     
    cartao = @cartao.clone
             
    cartao.ano_validade = nil
    assert_equal false, cartao.valid?
    
    cartao.ano_validade = '1'
    assert_equal false, cartao.valid?    
    
    cartao.ano_validade = '123'
    assert_equal false, cartao.valid?    
    
    cartao.ano_validade = 'aa'
    assert_equal false, cartao.valid?    

    cartao.ano_validade = '14'  
    assert cartao.valid?        
  end
        
  def test_validation_codigo_seguranca     
    cartao = @cartao.clone
                 
    cartao.codigo_seguranca = nil
    assert_equal false, cartao.valid?    
    
    cartao.codigo_seguranca = 'aaa'
    assert_equal false, cartao.valid?    
    
    cartao.codigo_seguranca = '123'    
    assert cartao.valid?            
  end
  
  def test_validation_ip_comprador        
    cartao = @cartao.clone
        
    cartao.ip_comprador = nil
    assert_equal false, cartao.valid?    
    
    cartao.ip_comprador = '123'
    assert_equal false, cartao.valid?    
    
    cartao.ip_comprador = '192.168.1.1'
    assert cartao.valid?            
  end  
end
