#!/bin/bash

# Script'in bulunduğu dizini belirle
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Proje kök dizinini belirle
PROJECT_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)

# Proje adını pubspec.yaml'dan al
PROJECT_NAME=$(grep "name: " "$PROJECT_ROOT/pubspec.yaml" | cut -d' ' -f2)

# screens dizinini doğru şekilde BASE_PATH olarak belirle
BASE_PATH="$PROJECT_ROOT/lib/screens"

# Kullanıcıdan ekran adını al
echo "Enter the screen name (e.g., add_business):"
read screen_name

# Küçük harfe çevir ve alt çizgili formata uyumlu hale getir
screen_name_snake_case=$(echo "$screen_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Büyük harf formatında sınıf ismi oluştur (CamelCase)
screen_name_pascal_case=$(echo "$screen_name_snake_case" | awk -F'_' '{for(i=1;i<=NF;++i) $i=toupper(substr($i,1,1)) substr($i,2)}1' OFS='')

# Hedef ekran yolu
screen_path="$BASE_PATH/$screen_name_snake_case"

# Eğer 'screens' klasörü yoksa oluştur
if [ ! -d "$BASE_PATH" ]; then
  mkdir -p "$BASE_PATH"
  echo "Created missing screens directory: $BASE_PATH"
fi

# Gerekli klasörleri oluştur
directories=(
  "$screen_path/viewmodels"
  "$screen_path/services"
  "$screen_path/views"
)

for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    echo "Created directory: $dir"
  fi
done

# Dosyaları oluştur ve içerik ekle
# ViewModel dosyası
view_model_file="$screen_path/viewmodels/${screen_name_snake_case}_view_model.dart"
if [ ! -f "$view_model_file" ]; then
  cat <<EOL > "$view_model_file"
import 'dart:async';
import 'package:${PROJECT_NAME}/base/viewmodels/base_view_model.dart';
import '../services/${screen_name_snake_case}_service.dart';

class ${screen_name_pascal_case}ViewModel extends BaseViewModel {
  final ${screen_name_pascal_case}Service service;
  
  ${screen_name_pascal_case}ViewModel({required this.service});

  @override
  FutureOr<void> init() {}
}
EOL
  echo "Created ViewModel: $view_model_file"
fi

# Service dosyası
service_file="$screen_path/services/${screen_name_snake_case}_service.dart"
if [ ! -f "$service_file" ]; then
  cat <<EOL > "$service_file"
class ${screen_name_pascal_case}Service {
  // TODO: Add service logic
}
EOL
  echo "Created Service: $service_file"
fi

# View dosyası
view_file="$screen_path/${screen_name_snake_case}_screen.dart"
if [ ! -f "$view_file" ]; then
  cat <<EOL > "$view_file"
import 'package:flutter/material.dart';
import 'package:${PROJECT_NAME}/base/views/base_view.dart';
import 'viewmodels/${screen_name_snake_case}_view_model.dart';
import 'services/${screen_name_snake_case}_service.dart';

class ${screen_name_pascal_case}Screen extends StatelessWidget {
  const ${screen_name_pascal_case}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      vmBuilder: (_) => ${screen_name_pascal_case}ViewModel(service: ${screen_name_pascal_case}Service()),
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, ${screen_name_pascal_case}ViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text('${screen_name_pascal_case} Screen')),
      body: Center(child: Text('Welcome to ${screen_name_pascal_case} Screen')),
    );
  }
}
EOL
  echo "Created View: $view_file"
fi

echo "Screen structure for '$screen_name' created successfully inside 'lib/screens'!"
