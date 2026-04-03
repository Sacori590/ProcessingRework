public enum Name {
    EMMA, LENA, CHLOE, MANON, CAMILLE,
    SARAH, INES, CLARA, LOUISE, EVA,
    JADE, SLINA, ZOE, AURORE, MILA,
    LUCIE, JULIE, MARTINE, AMELIA, YASMINE,
    MARGOT, CLEMENCE, MARGAUX, ANAIS, SORIALA,
    ALIZEE, AMANDINE, CLOTHILDE, HIBA, ROMANE;

    public static String getRandomName() {
        int randomIndex = (int) (Math.random() * Name.values().length);
        return Name.values()[randomIndex].toString();
    }
}
