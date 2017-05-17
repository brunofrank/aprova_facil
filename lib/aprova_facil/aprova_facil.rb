# -*- encoding: utf-8 -*-

class AprovaFacil
  class MissingEnvironmentException < StandardError; end
  class MissingConfigurationException < StandardError; end

  URL = 'https://www.aprovafacil.com/cgi-bin/APFW/'
  URL_TEST = 'https://teste.aprovafacil.com/cgi-bin/APFW/'
  
  COMPRAR = 'APC'
  CAPTURAR = 'CAP'
  CANCELAR = 'CAN'
  
  # Método usado para efetuar cobraças recorrentes
  def recobrar(transacao, valor, parcelas = '01', parcelamento_admin = true, documento)
    request_url = url(COMPRAR)
    request_params = {
      'TransacaoAnterior' => transacao,
      'ValorDocumento' => valor,
      'QuantidadeParcelas' => '%02d' % parcelas,
      'ParcelamentoAdministrador' => parcelamento_admin ? 'S' : 'N',
      'NumeroDocumento' => documento
    }
    xml_response = commit(request_url, request_params)
    treat_apc_response(xml_response)  
  end
  
  def aprovar(cartao_credito)    
    if cartao_credito.valid?
      request_url = url(COMPRAR)
      request_params = cartao_credito.to_params
      xml_response = commit(request_url, request_params)
      treat_apc_response(xml_response)
    else
      {:aprovada => false, :resultado => cartao_credito.errors.join('\\n')}
    end
  end
  
  def capturar(transacao)
    request_url = url(CAPTURAR)
    request_params = {'Transacao' => transacao}
    xml_response = commit(request_url, request_params)
    request_result = {}
    if xml_response
      response = REXML::Document.new(xml_response)
      response.elements.each 'ResultadoCAP' do |resultado|
        resultado.elements.each 'ResultadoSolicitacaoConfirmacao' do |resultado|
          request_result[:capturado] = !resultado.text.match(/Confirmado/).nil?
          request_result[:resultado] = resultado.text
        end        
      end
    else
      request_result[:capturado] = false
      request_result[:resultado] = 'Erro ­ Erro desconhecido'
    end
    
    request_result    
  end
  
  def cancelar(transacao)
    request_url = url(CANCELAR)
    request_params = {'Transacao' => transacao}
    xml_response = commit(request_url, request_params)
    request_result = {}
    if xml_response
      response = REXML::Document.new(xml_response)
      response.elements.each 'ResultadoCAN' do |resultado|
        resultado.elements.each 'ResultadoSolicitacaoCancelamento' do |resultado|
          request_result[:cancelado] = !resultado.text.match(/Cancelado/).nil? or !resultado.text.match(/Cancelamento/).nil?
          request_result[:resultado] = resultado.text
        end        
        
        resultado.elements.each 'NSUCancelamento' do |nsu_Cancelamento|
          request_result[:nsu_Cancelamento] = !nsu_Cancelamento.text
        end        
      end
    else
      request_result[:cancelado] = false
      request_result[:resultado] = 'Erro ­ Erro desconhecido'
    end
    
    request_result    
  end
  
  private
  
    def url(metodo)
      url = AprovaFacil::Config.teste? ? URL_TEST.clone : URL.clone
      url << AprovaFacil::Config.usuario
      url << '/'
      url << metodo
    end
    
    def commit(url, request_params)
      request_params.merge!({
        'ResponderEmUTF8' => 'S'
      })
      
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(uri.path)
      request.form_data = request_params
      response = http.start {|r| r.request request }
      response.body
    rescue Exception
      nil
    end      
    
    def treat_apc_response(xml_response)
      request_result = {}
      if xml_response
        response = REXML::Document.new(xml_response)
        response.elements.each 'ResultadoAPC' do |resultado|
          resultado.elements.each 'TransacaoAprovada' do |aprovada|
            request_result[:aprovada] = aprovada.text == 'True' ? true : false
          end

          resultado.elements.each 'ResultadoSolicitacaoAprovacao' do |resultado|
            request_result[:resultado] = resultado.text
          end        

          resultado.elements.each 'CodigoAutorizacao' do |codigo_autorizacao|
            request_result[:codigo_autorizacao] = codigo_autorizacao.text
          end        

          resultado.elements.each 'Transacao' do |transacao|
            request_result[:transacao] = transacao.text
          end        

          resultado.elements.each 'CartaoMascarado' do |cartao_mascarado|
            request_result[:cartao_mascarado] = cartao_mascarado.text
          end        

          resultado.elements.each 'NumeroDocumento' do |numero_documento|
            request_result[:numero_documento] = numero_documento.text
          end                
        end
      else
        request_result[:aprovada] = false
        request_result[:resultado] = 'Erro ­ Erro desconhecido'
      end   
      
      request_result   
    end
end