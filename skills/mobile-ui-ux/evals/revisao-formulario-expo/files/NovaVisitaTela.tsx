import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView, Alert, Image } from 'react-native';

export default function NovaVisitaTela({ navigation }: any) {
  const [obra, setObra] = useState('');
  const [observacao, setObservacao] = useState('');
  const [erro, setErro] = useState(false);

  function salvar() {
    if (!obra) { setErro(true); return; }
    Alert.alert('Salvo!');
    navigation.goBack();
  }

  function excluir() {
    navigation.goBack();
  }

  return (
    <View style={{ flex: 1, backgroundColor: '#FFFFFF' }}>
      <View style={{ height: 56, flexDirection: 'row', alignItems: 'center', paddingHorizontal: 10 }}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Image source={require('./voltar.png')} style={{ width: 20, height: 20 }} />
        </TouchableOpacity>
        <Text style={{ flex: 1, fontSize: 18, color: '#222' }}>Nova visita</Text>
        <TouchableOpacity onPress={salvar} style={{ padding: 4 }}>
          <Text style={{ color: '#1E88E5', fontSize: 13 }}>Salvar</Text>
        </TouchableOpacity>
      </View>
      <ScrollView style={{ padding: 10 }}>
        <Text style={{ fontSize: 12, color: '#999' }}>Obra</Text>
        <TextInput
          value={obra}
          onChangeText={setObra}
          style={{ height: 36, borderWidth: 0.5, borderColor: erro ? 'red' : '#DDD', fontSize: 14 }}
        />
        <Text style={{ fontSize: 12, color: '#999', marginTop: 10 }}>Observação</Text>
        <View style={{ height: 80 }}>
          <TextInput value={observacao} onChangeText={setObservacao} multiline style={{ fontSize: 14 }} />
        </View>
        <View style={{ flexDirection: 'row', marginTop: 20 }}>
          <TouchableOpacity onPress={excluir} style={{ backgroundColor: '#E53935', padding: 14, flex: 1 }}>
            <Text style={{ color: '#fff', textAlign: 'center' }}>Excluir</Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={salvar} style={{ backgroundColor: '#1E88E5', padding: 8, marginLeft: 4 }}>
            <Text style={{ color: '#fff' }}>Salvar</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </View>
  );
}
