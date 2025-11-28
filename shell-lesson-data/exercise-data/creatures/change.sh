#!/bin/bash

# ==========================================
# 설정 (변경이 필요한 경우 이곳을 수정하세요)
# ==========================================
SRC_EXT="dat"  # 원본 확장자
DST_EXT="txt"  # 변경할 확장자

# ==========================================
# 초기화
# ==========================================
# *.dat 파일이 없을 경우, literal string이 아닌 빈 목록으로 처리
shopt -s nullglob

count_total=0
count_success=0
count_skip=0

echo "=== 확장자 변환 작업 시작 (.$SRC_EXT -> .$DST_EXT) ==="

# 대상 파일 목록 배열로 저장
files=(*."$SRC_EXT")

# 대상 파일이 없는 경우 종료
if [ ${#files[@]} -eq 0 ]; then
    echo "오류: 현재 디렉토리에 .$SRC_EXT 파일이 없습니다."
    exit 1
fi

# ==========================================
# 메인 루프
# ==========================================
for file in "${files[@]}"; do
    # 대상 파일명 생성
    target="${file%.$SRC_EXT}.$DST_EXT"

    # [안전장치 1] 이미 변경된 파일명이 존재하는지 확인 (덮어쓰기 방지)
    if [ -e "$target" ]; then
        echo "[건너뜀] $file -> $target (이미 파일이 존재함)"
        ((count_skip++))
        continue
    fi

    # 파일 이름 변경 실행
    mv "$file" "$target"

    # [안전장치 2] mv 명령어가 성공했는지 확인
    if [ $? -eq 0 ]; then
        echo "[성공] $file -> $target"
        ((count_success++))
    else
        echo "[실패] $file 변환 중 오류 발생"
    fi
    
    ((count_total++))
done

# ==========================================
# 결과 리포트
# ==========================================
echo "------------------------------------------"
echo "작업 완료."
echo "총 시도: $count_total | 성공: $count_success | 건너뜀(중복): $count_skip"

