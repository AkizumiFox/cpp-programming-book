# C++ 程式設計：給學過 C 的人（繁體中文 C++ 銜接教材）

作者：林子祐（國立臺灣大學資訊工程學系）

一本寫給已經學完 C 的人的 C++ 銜接教材。 不從零教起，假設讀者熟悉 C 的變數、迴圈、陣列、函式、指標與結構，只講從 C 走到 C++ 需要補上的部分：參考、`string` 與 `vector`、物件的生命週期、類別、運算子多載、繼承、模板與 STL、迭代器與演算法。 篇幅刻意寫短，讀完可以接著學 APCS 中級、資料結構與演算法。

遇到 C 裡較進階的概念（指標、`malloc`/`free`、`struct`、`char[]` 字串），會先用一個「C 回顧」框把 C 的寫法講一遍，再看 C++ 怎麼做。 每一章的範例程式都可以直接用 `g++ -std=c++17 -Wall` 編譯執行，並附有常見錯誤與練習題。

- 第 1 章 PDF：[`output/chapters/01_FromCToCpp.pdf`](output/chapters/01_FromCToCpp.pdf)
- 第 2 章 PDF：[`output/chapters/02_ReferencesAndFunctions.pdf`](output/chapters/02_ReferencesAndFunctions.pdf)
- 第 3 章 PDF：[`output/chapters/03_StringAndVector.pdf`](output/chapters/03_StringAndVector.pdf)
- 第 4 章 PDF：[`output/chapters/04_Lifetime.pdf`](output/chapters/04_Lifetime.pdf)
- 第 5 章 PDF：[`output/chapters/05_Classes.pdf`](output/chapters/05_Classes.pdf)
- 第 6 章 PDF（草稿）：[`output/chapters/06_OperatorOverloading.pdf`](output/chapters/06_OperatorOverloading.pdf)
- 原始碼：`src/`（XeLaTeX）

## 章節

| # | 章 | 狀態 |
|---|---|---|
| 1 | 從 C 到 C++ | 完成 |
| 2 | 參考與函式 | 完成 |
| 3 | string 與 vector | 完成 |
| 4 | 生命週期 | 完成 |
| 5 | 類別 | 完成 |
| 6 | 運算子多載與複製 | 草稿 |
| 7 | 繼承與多型 | 未開始 |
| 8 | 模板與 STL 容器 | 未開始 |
| 9 | 迭代器與演算法 | 未開始 |
| 10 | 銜接 APCS 與資料結構 | 未開始 |

## 編譯

需要 XeLaTeX、latexmk 與 Python 的 Pygments（minted 上色用）。 中文字型在 macOS 上用 Songti TC／PingFang TC，找不到時改用 Noto Serif／Sans CJK TC。

```
make ch1     # 單章，輸出到 output/chapters/
make book    # 全書，輸出到 output/book.pdf
```

## 授權

CC BY-NC-SA 4.0。可自由用於教學與非商業用途，改作請沿用相同授權並註明出處。
