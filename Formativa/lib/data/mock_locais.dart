import '../models/local.dart';

const mockLocais = <Local>[
  Local(
    id: 'academia-fitness',
    nome: 'Academia Fitness',
    categoria: 'Academia',
    cidade: 'São Paulo',
    avaliacao: 4.8,
    distancia: 1.2,
    horario: 'Aberto · 06:00 - 22:00',
    descricao:
        'Um espaço completo para treino, bem-estar e movimento. Equipamentos modernos, ambiente acolhedor e profissionais preparados para acompanhar sua rotina.',
    favorito: true,
    totalAvaliacoes: 124,
    imagemUrl:
        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80',
  ),
  Local(
    id: 'smart-fit',
    nome: 'Smart Fit',
    categoria: 'Academia',
    cidade: 'São Paulo',
    avaliacao: 4.7,
    distancia: 1.2,
    horario: 'Aberto · 05:30 - 23:00',
    descricao: 'Treinos práticos e estrutura moderna perto de você.',
    favorito: false,
    totalAvaliacoes: 58,
    imagemUrl:
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=900&q=80',
  ),
  Local(
    id: 'body-center',
    nome: 'Body Center',
    categoria: 'Academia',
    cidade: 'São Paulo',
    avaliacao: 4.9,
    distancia: 2.1,
    horario: 'Aberto · 06:00 - 22:30',
    descricao: 'Uma academia boutique para cuidar de corpo e mente.',
    favorito: false,
    totalAvaliacoes: 82,
    imagemUrl:
        'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=900&q=80',
  ),
  Local(
    id: 'cafe-central',
    nome: 'Café Central',
    categoria: 'Restaurante',
    cidade: 'São Paulo',
    avaliacao: 4.6,
    distancia: 0.8,
    horario: 'Aberto · 08:00 - 20:00',
    descricao: 'Café especial, brunch e bons encontros no centro da cidade.',
    favorito: false,
    totalAvaliacoes: 96,
    imagemUrl:
        'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=900&q=80',
  ),
];
