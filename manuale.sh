#!/bin/bash

# =============================================================================
# manuale  –  Manuale degli Script Intranet
# Mostra descrizione e usage degli script disponibili nel progetto.
# =============================================================================

USAGE='Uso: manuale [SCRIPT]
Opzioni:
  log              Estrazione e filtraggio log di accesso.
  firewall         Analisi di sicurezza della rete intranet.
  bandwidth        Monitoraggio del consumo di banda per livello utente.
  outside_access   Rilevamento accessi da IP esterni alla subnet aziendale.
  audit_trail      Audit trail delle modifiche al file users.csv.
  backup           Backup e ripristino di users.csv e whitelist.conf.
  user_report      Report completo degli utenti suddivisi per livello.
  add_convert      Gestione utenti: aggiunta, eliminazione e modifica livello.
  log_rotation     Rotazione e archiviazione dei log di accesso.'


# Normalizza l'input: rimuove l'eventuale ./ iniziale e/o l'estensione .sh finale
SCRIPT="${1#./}"
SCRIPT="${SCRIPT%.sh}"


case "$SCRIPT" in

    # ------------------------------------------------------------------
    # LOG
    # ------------------------------------------------------------------
    log)
        echo ""
        echo "NOME"
        echo "    log.sh  –  Estrazione e filtraggio del log di accesso"
        echo ""
        echo "DESCRIZIONE"
        echo "    Analizza il file access.log e permette di estrarre voci"
        echo "    in base all'orario notturno, all'indirizzo IP, alla data"
        echo "    o a un intervallo di date e ore. I risultati vengono salvati"
        echo "    in file separati nella cartella logs_output/."
        echo ""
        echo "USO"
        echo '    ./log.sh [FLAG] [ARGOMENTI]'
        echo '    -a, --all                                             Estrae tutti i log avvenuti in orario notturno.'
        echo '    -t, --tail                                            Estrae gli ultimi 10 log avvenuti in orario notturno.'
        echo '    -i, --ip [IP_ADDRESS]                                 Estrae i log di un indirizzo IP specifico.'
        echo '    -d, --date [YYYY-MM-DD]                               Estrae i log di una data specifica.'
        echo '    -ds, --dates [YYYY-MM-DD_START] [YYYY-MM-DD_END]      Estrae i log in un intervallo di date.'
        echo '    -dt, --date-time [YYYY-MM-DD] [HH_START] [HH_END]     Estrae i log di una data specifica in un intervallo orario.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # FIREWALL
    # ------------------------------------------------------------------
    firewall)
        echo ""
        echo "NOME"
        echo "    firewall.sh  –  Analisi di sicurezza della rete intranet"
        echo ""
        echo "DESCRIZIONE"
        echo "    Esamina il log di accesso alla ricerca di comportamenti"
        echo "    sospetti: IP non presenti in whitelist, accessi notturni"
        echo "    con codice 400, IP in blacklist. Permette inoltre di"
        echo "    aggiungere manualmente IP alla blacklist e di generare"
        echo "    un report completo delle minacce rilevate."
        echo ""
        echo "USO"
        echo '    ./firewall.sh [FLAG] [ARGOMENTI]'
        echo '    -s, --scan          Scansiona il log per IP non presenti in whitelist.'
        echo '    -n, --night         Trova accessi notturni con codice di errore 400.'
        echo '    -b, --ban   [IP]    Aggiunge manualmente un IP alla blacklist.'
        echo '    -c, --check-ban     Controlla se IP bannati hanno tentato accessi.'
        echo '    -r, --report        Genera un report completo delle minacce.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # BANDWIDTH
    # ------------------------------------------------------------------
    bandwidth)
        echo ""
        echo "NOME"
        echo "    bandwidth.sh  –  Monitoraggio del consumo di banda per livello utente"
        echo ""
        echo "DESCRIZIONE"
        echo "    Incrocia il log di accesso con il CSV degli utenti per"
        echo "    calcolare il consumo di banda giornaliero di ciascun utente."
        echo "    Ogni accesso con codice 200 corrisponde a 512 KB consumati."
        echo "    Se il consumo supera la soglia prevista per il livello dell'utente,"
        echo "    viene generato un alert e inviata una email all'amministratore."
        echo "    Soglie: admin 200 MB | power_user 100 MB | guest 30 MB | disabled 0 MB."
        echo ""
        echo "USO"
        echo '    ./bandwidth.sh [YYYY-MM-DD]'
        echo '    [YYYY-MM-DD]    Analizza solo i log della data specificata.'
        echo '                    Senza argomenti analizza l'"'"'intero log.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # OUTSIDE_ACCESS
    # ------------------------------------------------------------------
    outside_access)
        echo ""
        echo "NOME"
        echo "    outside_access.sh  –  Rilevamento accessi da IP esterni alla subnet aziendale"
        echo ""
        echo "DESCRIZIONE"
        echo "    Scansiona il log di accesso alla ricerca di connessioni"
        echo "    provenienti da IP non appartenenti alla subnet interna"
        echo "    192.168.0.0/16. Qualsiasi altro indirizzo è considerato"
        echo "    esterno e quindi sospetto. Genera un report con i dettagli"
        echo "    degli accessi rilevati e i top IP esterni più frequenti."
        echo ""
        echo "USO"
        echo '    ./outside_access.sh [YYYY-MM-DD]'
        echo '    [YYYY-MM-DD]    Analizza solo i log della data specificata.'
        echo '                    Senza argomenti analizza l'"'"'intero log.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # AUDIT_TRAIL
    # ------------------------------------------------------------------
    audit_trail)
        echo ""
        echo "NOME"
        echo "    audit_trail.sh  –  Audit trail delle modifiche al file users.csv"
        echo ""
        echo "DESCRIZIONE"
        echo "    Confronta lo stato attuale di users.csv con uno snapshot"
        echo "    salvato in precedenza e registra ogni modifica rilevata:"
        echo "    utenti aggiunti, rimossi o modificati (livello, IP, mail,"
        echo "    password). Ad ogni esecuzione aggiorna lo snapshot."
        echo ""
        echo "USO"
        echo '    ./audit_trail.sh [OPZIONE]'
        echo '    (nessuna)   Confronta il CSV attuale con lo snapshot e registra le modifiche.'
        echo '    --init      Crea lo snapshot iniziale senza registrare modifiche.'
        echo '    --show      Mostra il log audit completo.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # BACKUP
    # ------------------------------------------------------------------
    backup)
        echo ""
        echo "NOME"
        echo "    backup.sh  –  Backup e ripristino di users.csv e whitelist.conf"
        echo ""
        echo "DESCRIZIONE"
        echo "    Crea backup timestampati di users.csv e whitelist.conf"
        echo "    nella cartella data/backups/. Mantiene automaticamente"
        echo "    solo gli ultimi 5 backup per file, eliminando i più vecchi."
        echo "    Permette di elencare i backup disponibili e di ripristinare"
        echo "    un backup precedente."
        echo ""
        echo "USO"
        echo '    ./backup.sh [OPZIONE]'
        echo '    (nessuna)        Esegue il backup di users.csv e whitelist.conf.'
        echo '    --list           Mostra i backup disponibili.'
        echo '    --restore [FILE] Ripristina un backup specifico (percorso completo).'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # USER_REPORT
    # ------------------------------------------------------------------
    user_report)
        echo ""
        echo "NOME"
        echo "    user_report.sh  –  Report completo degli utenti suddivisi per livello"
        echo ""
        echo "DESCRIZIONE"
        echo "    Genera una panoramica dettagliata di tutti gli utenti nel CSV,"
        echo "    suddivisi per livello (admin, power_user, guest, disabled)."
        echo "    Per ciascun utente mostra IP, numero di accessi riusciti (200)"
        echo "    ed errori (400), e data dell'ultimo accesso. Evidenzia inoltre"
        echo "    gli utenti sospetti con più errori che accessi riusciti."
        echo ""
        echo "USO"
        echo '    ./user_report.sh'
        echo '    (nessun argomento)   Genera il report completo e lo salva in logs_output/.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # ADD_CONVERT
    # ------------------------------------------------------------------
    add_convert)
        echo ""
        echo "NOME"
        echo "    add_convert.sh  –  Gestione utenti: aggiunta, eliminazione e modifica livello"
        echo ""
        echo "DESCRIZIONE"
        echo "    Interfaccia interattiva riservata agli amministratori (livello 3)"
        echo "    per la gestione del file users.csv. Dopo un login con mail e"
        echo "    password, permette di aggiungere nuovi utenti con validazione"
        echo "    di password e IP, eliminare utenti esistenti e modificare"
        echo "    il livello di accesso di un utente."
        echo ""
        echo "USO"
        echo '    ./add_convert.sh'
        echo '    (nessun argomento)   Avvia il login interattivo per accedere al menù di gestione.'
        echo '    Opzioni menù:'
        echo '    1. Aggiungere un utente'
        echo '    2. Eliminare un utente'
        echo '    3. Modificare il livello di un utente'
        echo '    4. Uscire'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # LOG_ROTATION
    # ------------------------------------------------------------------
    log_rotation)
        echo ""
        echo "NOME"
        echo "    log_rotation.sh  –  Rotazione e archiviazione dei log di accesso"
        echo ""
        echo "DESCRIZIONE"
        echo "    Archivia le righe del log più vecchie di 30 giorni rispetto"
        echo "    alla data più recente presente nel log stesso (non la data"
        echo "    di sistema, per compatibilità con log simulati). Le righe"
        echo "    archiviate vengono salvate in logs/archive/ con nome basato"
        echo "    sul range di date contenuto."
        echo ""
        echo "USO"
        echo '    ./log_rotation.sh [OPZIONE]'
        echo '    (nessuna)   Archivia le righe del log più vecchie di 30 giorni.'
        echo '    --undo      Ripristina l'"'"'ultimo archivio nel log attivo e lo riordina cronologicamente.'
        echo ""
        ;;

    # ------------------------------------------------------------------
    # Uso non valido o nessun argomento
    # ------------------------------------------------------------------
    *)
        if [[ -n "$SCRIPT" ]]; then
            echo ""
            echo "Errore: script '$1' non riconosciuto o non documentato."
            echo ""
        fi
        echo "$USAGE"
        exit 1
        ;;

esac