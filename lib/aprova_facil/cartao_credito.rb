# -*- encoding: utf-8 -*-

class AprovaFacil
  class CartaoCredito
    
    module Bandeira
      VISA       = 'VISA'
      MASTERCARD = 'MASTERCARD'
      DINERS     = 'DINERS'    
      AMEX       = 'AMEX'      
      HIPERCARD  = 'HIPERCARD'
      JCB        = 'JCB'
      SOROCRED   = 'SOROCRED'
      AURA       = 'AURA' 
    end
    
    attr_accessor :documento, :valor, :parcelas, :numero_cartao, :codigo_seguranca,
                  :mes_validade, :ano_validade, :pre_autorizacao, :ip_comprador, 
                  :nome_portador, :bandeira, :cpf_portador, :data_nascimento, 
                  :nome_mae, :parcelamento_administradora, :transacao_anterior, :errors
    
    def initialize(options={})
      @documento                    = options[:documento]
      @valor                        = options[:valor]
      @parcelas                     = options[:parcelas] || 1
      @numero_cartao                = options[:numero_cartao]
      @codigo_seguranca             = options[:codigo_seguranca]
      @mes_validade                 = options[:mes_validade]
      @ano_validade                 = options[:ano_validade]
      @pre_autorizacao              = options[:pre_autorizacao] || false
      @ip_comprador                 = options[:ip_comprador]
      @nome_portador                = options[:nome_portador]
      @bandeira                     = options[:bandeira] || Bandeira::VISA
      @cpf_portador                 = options[:cpf_portador]
      @data_nascimento              = options[:data_nascimento]
      @nome_mae                     = options[:nome_mae]
      @parcelamento_administradora  = options[:parcelamento_administradora] || true
      @transacao_anterior           = options[:transacao_anterior]
      
      @errors = []
    end 
      
    def valid?
      errors.clear
      errors << {:valor => 'deve ser informado'} if valor.nil? or !valor.kind_of?(Float) or valor == 0
      
      if parcelas.nil? or (parcelas.kind_of?(Integer) and parcelas == 0)
        errors << {:parcelas => 'deve ser informado'} 
      end
      
      errors << {:numero_cartao => 'deve ser informado'} if numero_cartao.nil? or numero_cartao.empty?
      
      if mes_validade.nil? or mes_validade.empty?        
        errors << {:mes_validade => 'deve ser informado'} 
      elsif mes_validade.size != 2 or mes_validade.match(/\D/)
        errors << {:mes_validade => 'deve ser informado'} 
      end
      
      if ano_validade.nil? or ano_validade.empty?        
        errors << {:ano_validade => 'deve ser informado'} 
      elsif ano_validade.size != 2 or ano_validade.match(/\D/)
        errors << {:ano_validade => 'deve ter 2 dígitos numéricos'} 
      end        
      
      if codigo_seguranca.nil? or codigo_seguranca.empty?        
        errors << {:codigo_seguranca => 'deve ser informado'} 
      elsif codigo_seguranca.match(/\D/)
        errors << {:ano_validade => 'deve até 4 dígitos numéricos'} 
      end        
      
      if ip_comprador.nil? or ip_comprador.empty?
        errors << {:ip_comprador => 'deve ser informado'}
      elsif !ip_comprador.match(/\d+\.\d+\.\d+\.\d+/)
        errors << {:ip_comprador => 'Dese Tem que ser no formato 000.000.000.000'} 
      end        
      
      errors.size == 0
    end
    
    def to_params
      params = {}
      params['NumeroDocumento']              = self.documento[0, 50] if self.documento
      params['ValorDocumento']               = self.valor
      params['QuantidadeParcelas']           = '%02d' % self.parcelas 
      params['NumeroCartao']                 = self.numero_cartao
      params['MesValidade']                  = '%02d' % self.mes_validade
      params['AnoValidade']                  = '%02d' % self.ano_validade
      params['CodigoSeguranc']               = self.codigo_seguranca
      params['PreAutorizacao']               = self.pre_autorizacao ? 'S' : 'N'
      params['EnderecoIPComprado']           = self.ip_comprador
      params['NomePortadorCarta']            = self.nome_portador if self.nome_portador
      params['Bandeira']                     = self.bandeira
      params['CPFPortadorCartao']            = self.cpf_portador.gsub /\D/, '' if self.cpf_portador
      params['DataNascimentoPortadorCartao'] = self.data_nascimento.strftime('%Y%m%d') if self.data_nascimento and self.data_nascimento.kind_of?(Date)
      params['NomeMaePortadorCarta']         = self.nome_mae if self.nome_mae
      params['ParcelamentoAdministrador']    = self.parcelamento_administradora ? 'S' : 'N'

      params    
    end    
  end
end