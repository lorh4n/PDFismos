# Progresso de leitura

O aplicativo guarda a página de cada PDF na tabela `reading_progress`. A coluna `document_id` identifica o documento e `page_index` guarda o índice da página: a primeira página tem índice `0`, então a página 5 aparece como `4` no banco.

Quando a página muda, `PdfMultiPageView.currentPage` passa pelo `LibraryController` até `saveDocumentProgress()`. A consulta cria o registro na primeira vez e atualiza a mesma linha nas próximas. Ao abrir um PDF, `readingProgress()` consulta sua página salva; se não houver registro, retorna `0`.

O documento pode ficar pronto antes de o leitor receber tamanho na tela. Por isso, `pendingPageIndex` guarda a página desejada e `restorePageIfReady()` espera o PDF estar pronto, a biblioteca estar fechada e o leitor ter largura e altura maiores que zero. Então chama `goToPage()` e limpa a página pendente.

Enquanto `restoringLastPage` é verdadeiro, as mudanças de página não são gravadas. Isso evita substituir o progresso salvo por uma página intermediária durante a abertura.
